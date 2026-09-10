import 'package:hive/hive.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/destination_model.dart';
import '../models/hotel_model.dart';

abstract class HotelLocalDataSource {
  Future<List<HotelModel>> getCachedHotels();
  Future<void> cacheHotels(List<HotelModel> hotels);

  Future<List<DestinationModel>> getCachedDestinations();
  Future<void> cacheDestinations(List<DestinationModel> destinations);

  Future<HotelModel?> getCachedHotelById(String id);
}

class HotelLocalDataSourceImpl implements HotelLocalDataSource {
  final Box box;

  HotelLocalDataSourceImpl({required this.box});

  @override
  Future<List<HotelModel>> getCachedHotels() async {
    try {
      final raw = box.get(StorageConstants.cachedHotelsKey);
      if (raw == null) return [];
      final List list = raw as List;
      return list.map((e) => HotelModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to read cached hotels: $e');
    }
  }

  @override
  Future<void> cacheHotels(List<HotelModel> hotels) async {
    try {
      final list = hotels.map((h) => h.toJson()).toList();
      await box.put(StorageConstants.cachedHotelsKey, list);
    } catch (e) {
      throw CacheException(message: 'Failed to cache hotels: $e');
    }
  }

  @override
  Future<List<DestinationModel>> getCachedDestinations() async {
    try {
      final raw = box.get(StorageConstants.cachedDestinationsKey);
      if (raw == null) return [];
      final List list = raw as List;
      return list.map((e) => DestinationModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to read cached destinations: $e');
    }
  }

  @override
  Future<void> cacheDestinations(List<DestinationModel> destinations) async {
    try {
      final list = destinations.map((d) => d.toJson()).toList();
      await box.put(StorageConstants.cachedDestinationsKey, list);
    } catch (e) {
      throw CacheException(message: 'Failed to cache destinations: $e');
    }
  }

  @override
  Future<HotelModel?> getCachedHotelById(String id) async {
    try {
      final hotels = await getCachedHotels();
      final match = hotels.where((h) => h.id == id);
      return match.isNotEmpty ? match.first : null;
    } catch (e) {
      throw CacheException(message: 'Failed to find cached hotel: $e');
    }
  }
}
