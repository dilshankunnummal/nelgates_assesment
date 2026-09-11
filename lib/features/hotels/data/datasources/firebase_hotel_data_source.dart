import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/mock_hotel_data.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/destination_model.dart';
import '../models/hotel_model.dart';
import 'hotel_remote_data_source.dart';

class FirebaseHotelDataSourceImpl implements HotelRemoteDataSource {
  FirebaseFirestore? _firestore;

  FirebaseHotelDataSourceImpl({this._firestore});

  FirebaseFirestore get _db => _firestore ??= FirebaseFirestore.instance;

  @override
  Future<List<HotelModel>> getHotels({
    String? search,
    String? destination,
    double? minPrice,
    double? maxPrice,
    double? rating,
    String? sort,
  }) async {
    try {
      List<HotelModel> hotels = [];
      try {
        AppLogger.firebase('Querying hotels collection from Firestore...');
        var snapshot = await _db.collection('hotels').get(const GetOptions(source: Source.serverAndCache));
        
        if (snapshot.docs.isEmpty) {
          AppLogger.firebase('Firestore hotels collection is empty. Populating initial seed to Firestore...');
          for (final hotel in mockHotelsData) {
            await _db.collection('hotels').doc(hotel['id'].toString()).set({
              ...hotel,
              'created_at': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
          }
          snapshot = await _db.collection('hotels').get();
        }

        if (snapshot.docs.isNotEmpty) {
          hotels = snapshot.docs.map((doc) => HotelModel.fromJson(_sanitizeHotelData(doc.data()))).toList();
          AppLogger.firebase('Loaded ${hotels.length} hotels live from Cloud Firestore.', isSuccess: true);
        }
      } catch (firestoreError, stack) {
        AppLogger.firebase('Firestore query error (check network or security rules)', error: firestoreError, stackTrace: stack);
        // Throw NetworkException so repository can serve offline cache or display No Internet error view
        throw NetworkException(
          message: 'Unable to connect to hotel services. Please check your internet connection and try again.',
        );
      }

      // In-memory advanced query filtering
      if (search != null && search.trim().isNotEmpty) {
        final q = search.toLowerCase().trim();
        hotels = hotels.where((h) {
          return h.name.toLowerCase().contains(q) ||
              h.destination.toLowerCase().contains(q) ||
              h.city.toLowerCase().contains(q) ||
              h.state.toLowerCase().contains(q) ||
              h.description.toLowerCase().contains(q);
        }).toList();
      }

      if (destination != null && destination.isNotEmpty && destination.toLowerCase() != 'all') {
        final d = destination.toLowerCase().trim();
        hotels = hotels.where((h) =>
            h.destination.toLowerCase().contains(d) ||
            h.city.toLowerCase().contains(d) ||
            h.state.toLowerCase().contains(d)).toList();
      }

      if (minPrice != null) {
        hotels = hotels.where((h) => h.pricePerNight >= minPrice).toList();
      }

      if (maxPrice != null) {
        hotels = hotels.where((h) => h.pricePerNight <= maxPrice).toList();
      }

      if (rating != null) {
        hotels = hotels.where((h) => h.rating >= rating).toList();
      }

      if (sort != null) {
        if (sort == 'price_low_high') {
          hotels.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
        } else if (sort == 'price_high_low') {
          hotels.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
        } else if (sort == 'rating') {
          hotels.sort((a, b) => b.rating.compareTo(a.rating));
        }
      }

      return hotels;
    } catch (e, stack) {
      AppLogger.firebase('Failed to query hotels', error: e, stackTrace: stack);
      if (e is NetworkException || e is ServerException) rethrow;
      throw ServerException(message: 'Failed to fetch hotels from Firebase: $e');
    }
  }

  @override
  Future<HotelModel> getHotelById(String id) async {
    try {
      try {
        AppLogger.firebase('Fetching hotel details for ID: $id...');
        final doc = await _db.collection('hotels').doc(id).get();
        if (doc.exists && doc.data() != null) {
          AppLogger.firebase('Found hotel document for ID: $id in Firestore.', isSuccess: true);
          return HotelModel.fromJson(_sanitizeHotelData(doc.data()!));
        }
      } catch (err) {
        AppLogger.warning('Firestore single hotel query error ($id), checking fallback: $err', tag: 'HOTELS 🏨');
      }

      // Check fallback data
      final fallback = mockHotelsData.firstWhere(
        (h) => h['id'] == id,
        orElse: () => throw ServerException(message: 'Hotel not found with ID: $id'),
      );
      return HotelModel.fromJson(_sanitizeHotelData(fallback));
    } catch (e) {
      AppLogger.error('Failed to get hotel by ID: $id', tag: 'HOTELS 🏨', error: e);
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Failed to fetch hotel details: $e');
    }
  }

  Map<String, dynamic> _sanitizeHotelData(Map<String, dynamic> data) {
    if (data.containsKey('images') && data['images'] is List) {
      final List<dynamic> imgs = (data['images'] as List).map((e) {
        final str = e.toString();
        if (str.contains('1603287681836-e174ce71a8c8')) {
          return 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80';
        }
        return str;
      }).toList();
      return {...data, 'images': imgs};
    }
    return data;
  }

  @override
  Future<List<DestinationModel>> getDestinations() async {
    try {
      try {
        AppLogger.firebase('Fetching destinations from Firestore...');
        var snapshot = await _db.collection('destinations').get(const GetOptions(source: Source.serverAndCache));
        
        if (snapshot.docs.isEmpty) {
          AppLogger.firebase('Firestore destinations empty. Seeding to Firestore...');
          final batch = _db.batch();
          for (final d in mockDestinationsData) {
            batch.set(_db.collection('destinations').doc(d['id'].toString()), {
              ...d,
              'created_at': FieldValue.serverTimestamp(),
            });
          }
          await batch.commit();
          snapshot = await _db.collection('destinations').get();
        }

        if (snapshot.docs.isNotEmpty) {
          final destinations = snapshot.docs.map((doc) => DestinationModel.fromJson(doc.data())).toList();
          AppLogger.firebase('Loaded ${destinations.length} destinations live from Cloud Firestore.', isSuccess: true);
          return destinations;
        }

        return [];
      } catch (err) {
        AppLogger.warning('Firestore destinations query error: $err', tag: 'DESTINATIONS 🌴');
        throw NetworkException(message: 'Unable to load destinations. Please check your internet connection and try again.');
      }
    } catch (e) {
      AppLogger.error('Failed to fetch destinations', tag: 'DESTINATIONS 🌴', error: e);
      if (e is NetworkException || e is ServerException) rethrow;
      throw ServerException(message: 'Failed to fetch destinations from Firebase: $e');
    }
  }
}
