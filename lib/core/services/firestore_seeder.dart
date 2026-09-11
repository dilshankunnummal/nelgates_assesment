import 'package:cloud_firestore/cloud_firestore.dart';
import '../network/mock_hotel_data.dart';
import '../utils/app_logger.dart';

class FirestoreSeeder {
  FirebaseFirestore? _firestore;

  FirestoreSeeder({this._firestore});

  FirebaseFirestore get _db => _firestore ??= FirebaseFirestore.instance;

  /// Seeds initial mock destinations and hotels into Firestore if not already present
  Future<void> seedInitialData() async {
    try {
      AppLogger.seeder('Checking Firestore collections for initial seed...');

      // 1. Seed Destinations
      final destinationsSnapshot = await _db.collection('destinations').limit(1).get();
      if (destinationsSnapshot.docs.isEmpty) {
        AppLogger.seeder('Seeding ${mockDestinationsData.length} destinations into Firestore...');
        final batch = _db.batch();
        for (final dest in mockDestinationsData) {
          final docRef = _db.collection('destinations').doc(dest['id'].toString());
          batch.set(docRef, {
            ...dest,
            'created_at': FieldValue.serverTimestamp(),
          });
        }
        await batch.commit();
        AppLogger.seeder('Destinations seeded successfully.', isSuccess: true);
      } else {
        AppLogger.seeder('Destinations collection already contains data. Skipping seed.');
      }

      // 2. Seed Hotels
      final hotelsSnapshot = await _db.collection('hotels').limit(1).get();
      if (hotelsSnapshot.docs.isEmpty) {
        AppLogger.seeder('Seeding ${mockHotelsData.length} hotels into Firestore...');
        for (final hotel in mockHotelsData) {
          final docRef = _db.collection('hotels').doc(hotel['id'].toString());
          await docRef.set({
            ...hotel,
            'created_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
        AppLogger.seeder('Hotels seeded successfully.', isSuccess: true);
      } else {
        AppLogger.seeder('Hotels collection already contains data. Checking for image fixes...');
        try {
          final lalithaDoc = await _db.collection('hotels').doc('HTL-KAR-002').get();
          if (lalithaDoc.exists) {
            final data = lalithaDoc.data();
            final images = (data?['images'] as List?)?.map((e) => e.toString()).toList();
            if (images != null && images.any((img) => img.contains('1603287681836-e174ce71a8c8'))) {
              final fixedImages = images
                  .map((img) => img.contains('1603287681836-e174ce71a8c8')
                      ? 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80'
                      : img)
                  .toList();
              await _db.collection('hotels').doc('HTL-KAR-002').update({'images': fixedImages});
              AppLogger.seeder('Healed Lalitha Mahal Palace Hotel thumbnail in Firestore.', isSuccess: true);
            }
          }
        } catch (_) {}
      }
    } catch (e, stackTrace) {
      AppLogger.seeder('Failed to seed Firestore data', error: e);
      AppLogger.error('Firestore seeder encountered an error: $e', tag: 'SEEDER 🌱', stackTrace: stackTrace);
    }
  }
}

