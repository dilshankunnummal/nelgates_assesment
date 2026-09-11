import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/mock_hotel_data.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/destination_utils.dart';
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

        if (snapshot.docs.isNotEmpty) {
          hotels = snapshot.docs.map((doc) => HotelModel.fromJson(_sanitizeHotelData(doc.data()))).toList();
          AppLogger.firebase('Loaded ${hotels.length} hotels live from Cloud Firestore.', isSuccess: true);
        }

        final existingHotelIds = hotels.map((h) => h.id).toSet();
        final missingMockHotels = mockHotelsData
            .where((m) => !existingHotelIds.contains(m['id']))
            .toList();

        if (missingMockHotels.isNotEmpty) {
          AppLogger.firebase('Merging ${missingMockHotels.length} missing hotel properties from catalog...');
          final parsedMissing = missingMockHotels
              .map((m) => HotelModel.fromJson(_sanitizeHotelData(m)))
              .toList();
          hotels.addAll(parsedMissing);

          for (final m in missingMockHotels) {
            _db.collection('hotels').doc(m['id'].toString()).set({
              ...m,
              'created_at': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true)).catchError((e) {
              AppLogger.warning('Background sync hotel error: $e');
            });
          }
        }
      } catch (firestoreError, stack) {
        AppLogger.firebase('Firestore query error (check network or security rules)', error: firestoreError, stackTrace: stack);

        hotels = mockHotelsData.map((m) => HotelModel.fromJson(_sanitizeHotelData(m))).toList();
      }

      if (search != null && search.trim().isNotEmpty) {
        final q = search.toLowerCase().trim();
        final searchAliases = DestinationUtils.getAliases(q);
        hotels = hotels.where((h) {
          final name = h.name.toLowerCase();
          final dest = h.destination.toLowerCase();
          final city = h.city.toLowerCase();
          final state = h.state.toLowerCase();
          final desc = h.description.toLowerCase();

          return searchAliases.any((alias) =>
              name.contains(alias) ||
              dest.contains(alias) ||
              city.contains(alias) ||
              state.contains(alias) ||
              desc.contains(alias));
        }).toList();
      }

      if (destination != null && destination.isNotEmpty && destination.toLowerCase() != 'all') {
        hotels = hotels.where((h) => DestinationUtils.matchesDestination(
          hotelDestination: h.destination,
          hotelCity: h.city,
          hotelState: h.state,
          targetDestination: destination,
        )).toList();
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
      throw ServerException(message: 'Failed to fetch hotels: $e');
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
      List<DestinationModel> destinations = [];
      try {
        AppLogger.firebase('Fetching destinations from Firestore...');
        var snapshot = await _db.collection('destinations').get(const GetOptions(source: Source.serverAndCache));

        if (snapshot.docs.isNotEmpty) {
          destinations = snapshot.docs.map((doc) => DestinationModel.fromJson(doc.data())).toList();
          AppLogger.firebase('Loaded ${destinations.length} destinations live from Cloud Firestore.', isSuccess: true);
        }

        final existingDestIds = destinations.map((d) => d.id).toSet();
        final missingDestinations = mockDestinationsData
            .where((m) => !existingDestIds.contains(m['id']))
            .map((m) => DestinationModel.fromJson(m))
            .toList();
        if (missingDestinations.isNotEmpty) {
          destinations.addAll(missingDestinations);
        }

        final mockCountMap = {
          for (final d in mockDestinationsData) d['id'].toString(): (d['hotel_count'] as int? ?? 1)
        };
        destinations = destinations.map((d) {
          if (mockCountMap.containsKey(d.id)) {
            final expected = mockCountMap[d.id]!;
            if (d.hotelCount < expected) {
              return DestinationModel.fromEntity(d.copyWith(hotelCount: expected));
            }
          }
          return d;
        }).toList();

        return destinations;
      } catch (err) {
        AppLogger.warning('Firestore destinations query error: $err, serving local catalog', tag: 'DESTINATIONS 🌴');
        return mockDestinationsData.map((d) => DestinationModel.fromJson(d)).toList();
      }
    } catch (e) {
      AppLogger.error('Failed to fetch destinations', tag: 'DESTINATIONS 🌴', error: e);
      return mockDestinationsData.map((d) => DestinationModel.fromJson(d)).toList();
    }
  }
}
