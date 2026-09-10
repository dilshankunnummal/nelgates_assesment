import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/destination.dart';
import '../../domain/entities/hotel.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../datasources/hotel_local_data_source.dart';
import '../datasources/hotel_remote_data_source.dart';

class HotelRepositoryImpl implements HotelRepository {
  final HotelRemoteDataSource remoteDataSource;
  final HotelLocalDataSource localDataSource;

  HotelRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<({Failure? failure, List<Hotel>? hotels})> getHotels({
    String? search,
    String? destination,
    double? minPrice,
    double? maxPrice,
    double? rating,
    String? sort,
  }) async {
    try {
      final remoteHotels = await remoteDataSource.getHotels(
        search: search,
        destination: destination,
        minPrice: minPrice,
        maxPrice: maxPrice,
        rating: rating,
        sort: sort,
      );

      // Cache when full list is fetched
      if ((search == null || search.isEmpty) &&
          (destination == null || destination.isEmpty) &&
          minPrice == null &&
          maxPrice == null &&
          rating == null) {
        await localDataSource.cacheHotels(remoteHotels);
      }

      return (failure: null, hotels: remoteHotels);
    } on NetworkException catch (_) {
      // Attempt local cache fallback
      final cached = await localDataSource.getCachedHotels();
      if (cached.isNotEmpty) {
        return (failure: null, hotels: cached);
      }
      return (
        failure: const NetworkFailure('Unable to connect. No cached hotel data available.'),
        hotels: null,
      );
    } on ServerException catch (e) {
      final cached = await localDataSource.getCachedHotels();
      if (cached.isNotEmpty) {
        return (failure: null, hotels: cached);
      }
      return (failure: ServerFailure(e.message, statusCode: e.statusCode), hotels: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), hotels: null);
    }
  }

  @override
  Future<({Failure? failure, Hotel? hotel})> getHotelById(String id) async {
    try {
      final hotel = await remoteDataSource.getHotelById(id);
      return (failure: null, hotel: hotel);
    } on NetworkException catch (_) {
      final cached = await localDataSource.getCachedHotelById(id);
      if (cached != null) {
        return (failure: null, hotel: cached);
      }
      return (
        failure: const NetworkFailure('Unable to load hotel details offline.'),
        hotel: null,
      );
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message, statusCode: e.statusCode), hotel: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), hotel: null);
    }
  }

  @override
  Future<({Failure? failure, List<Destination>? destinations})> getDestinations() async {
    try {
      final remoteDestinations = await remoteDataSource.getDestinations();
      await localDataSource.cacheDestinations(remoteDestinations);
      return (failure: null, destinations: remoteDestinations);
    } on NetworkException catch (_) {
      final cached = await localDataSource.getCachedDestinations();
      if (cached.isNotEmpty) {
        return (failure: null, destinations: cached);
      }
      return (
        failure: const NetworkFailure('Unable to load destinations offline.'),
        destinations: null,
      );
    } on ServerException catch (e) {
      final cached = await localDataSource.getCachedDestinations();
      if (cached.isNotEmpty) {
        return (failure: null, destinations: cached);
      }
      return (failure: ServerFailure(e.message, statusCode: e.statusCode), destinations: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), destinations: null);
    }
  }
}
