import 'package:cloud_firestore/cloud_firestore.dart';
import '../network/mock_hotel_data.dart';
import '../utils/app_logger.dart';

class FirestoreSeeder {
  FirebaseFirestore? _firestore;

  FirestoreSeeder({this._firestore});

  FirebaseFirestore get _db => _firestore ??= FirebaseFirestore.instance;

  Future<void> seedInitialData() async {
    try {
      AppLogger.seeder('Checking Firestore collections for initial seed...');

      AppLogger.seeder('Syncing ${mockDestinationsData.length} destinations into Firestore in batch...');
      final destBatch = _db.batch();
      for (final dest in mockDestinationsData) {
        final docRef = _db.collection('destinations').doc(dest['id'].toString());
        destBatch.set(docRef, {
          ...dest,
          'created_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      await destBatch.commit();
      AppLogger.seeder('Destinations synchronized successfully.', isSuccess: true);

      AppLogger.seeder('Syncing ${mockHotelsData.length} hotels into Firestore in batch...');
      final hotelBatch = _db.batch();
      for (final hotel in mockHotelsData) {
        final docRef = _db.collection('hotels').doc(hotel['id'].toString());
        hotelBatch.set(docRef, {
          ...hotel,
          'created_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      await hotelBatch.commit();
      AppLogger.seeder('Hotels synchronized successfully.', isSuccess: true);
    } catch (e, stackTrace) {
      AppLogger.seeder('Failed to seed Firestore data', error: e);
      AppLogger.error('Firestore seeder encountered an error: $e', tag: 'SEEDER 🌱', stackTrace: stackTrace);
    }
  }
}
