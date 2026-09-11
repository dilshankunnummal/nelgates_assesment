import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/mock_hotel_data.dart';
import '../../../../core/utils/destination_utils.dart';
import '../../domain/entities/destination.dart';
import '../../domain/entities/hotel.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../datasources/hotel_local_data_source.dart';
import '../datasources/hotel_remote_data_source.dart';
import '../models/destination_model.dart';
import '../models/hotel_model.dart';

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

      if ((search == null || search.isEmpty) &&
          (destination == null || destination.isEmpty) &&
          minPrice == null &&
          maxPrice == null &&
          rating == null) {
        await localDataSource.cacheHotels(remoteHotels);
      }

      return (failure: null, hotels: remoteHotels);
    } on NetworkException catch (_) {

      final cached = await localDataSource.getCachedHotels();
      if (cached.isNotEmpty) {
        final filtered = _filterHotels(
          hotels: cached,
          search: search,
          destination: destination,
          minPrice: minPrice,
          maxPrice: maxPrice,
          rating: rating,
          sort: sort,
        );
        return (failure: null, hotels: filtered);
      }
      return (
        failure: const NetworkFailure('Unable to connect. No cached hotel data available.'),
        hotels: null,
      );
    } on ServerException catch (e) {
      final cached = await localDataSource.getCachedHotels();
      if (cached.isNotEmpty) {
        final filtered = _filterHotels(
          hotels: cached,
          search: search,
          destination: destination,
          minPrice: minPrice,
          maxPrice: maxPrice,
          rating: rating,
          sort: sort,
        );
        return (failure: null, hotels: filtered);
      }
      return (failure: ServerFailure(e.message, statusCode: e.statusCode), hotels: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), hotels: null);
    }
  }

  List<Hotel> _filterHotels({
    required List<Hotel> hotels,
    String? search,
    String? destination,
    double? minPrice,
    double? maxPrice,
    double? rating,
    String? sort,
  }) {
    var result = List<Hotel>.from(hotels);

    if (search != null && search.trim().isNotEmpty) {
      final q = search.toLowerCase().trim();
      final searchAliases = DestinationUtils.getAliases(q);
      result = result.where((h) {
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
      result = result.where((h) => DestinationUtils.matchesDestination(
        hotelDestination: h.destination,
        hotelCity: h.city,
        hotelState: h.state,
        targetDestination: destination,
      )).toList();
    }

    if (minPrice != null) {
      result = result.where((h) => h.pricePerNight >= minPrice).toList();
    }

    if (maxPrice != null) {
      result = result.where((h) => h.pricePerNight <= maxPrice).toList();
    }

    if (rating != null) {
      result = result.where((h) => h.rating >= rating).toList();
    }

    if (sort != null) {
      if (sort == 'price_low_high') {
        result.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
      } else if (sort == 'price_high_low') {
        result.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
      } else if (sort == 'rating') {
        result.sort((a, b) => b.rating.compareTo(a.rating));
      }
    }

    return result;
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
      final fallback = mockHotelsData.where((m) => m['id'] == id);
      if (fallback.isNotEmpty) {
        return (failure: null, hotel: HotelModel.fromJson(fallback.first));
      }
      return (
        failure: const NetworkFailure('Unable to load hotel details offline.'),
        hotel: null,
      );
    } on ServerException catch (e) {
      final cached = await localDataSource.getCachedHotelById(id);
      if (cached != null) {
        return (failure: null, hotel: cached);
      }
      final fallback = mockHotelsData.where((m) => m['id'] == id);
      if (fallback.isNotEmpty) {
        return (failure: null, hotel: HotelModel.fromJson(fallback.first));
      }
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
      final fallback = mockDestinationsData.map((d) => DestinationModel.fromJson(d)).toList();
      return (failure: null, destinations: fallback);
    } on ServerException catch (e) {
      final cached = await localDataSource.getCachedDestinations();
      if (cached.isNotEmpty) {
        return (failure: null, destinations: cached);
      }
      final fallback = mockDestinationsData.map((d) => DestinationModel.fromJson(d)).toList();
      return (failure: null, destinations: fallback);
    } catch (e) {
      final fallback = mockDestinationsData.map((d) => DestinationModel.fromJson(d)).toList();
      return (failure: null, destinations: fallback);
    }
  }
}
