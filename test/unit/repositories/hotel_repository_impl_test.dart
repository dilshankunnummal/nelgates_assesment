import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/core/error/exceptions.dart';
import 'package:nelegate_assessment/core/error/failures.dart';
import 'package:nelegate_assessment/features/hotels/data/datasources/hotel_local_data_source.dart';
import 'package:nelegate_assessment/features/hotels/data/datasources/hotel_remote_data_source.dart';
import 'package:nelegate_assessment/features/hotels/data/models/hotel_model.dart';
import 'package:nelegate_assessment/features/hotels/data/repositories/hotel_repository_impl.dart';

class MockHotelRemoteDataSource extends Mock implements HotelRemoteDataSource {}
class MockHotelLocalDataSource extends Mock implements HotelLocalDataSource {}

void main() {
  late MockHotelRemoteDataSource mockRemoteDataSource;
  late MockHotelLocalDataSource mockLocalDataSource;
  late HotelRepositoryImpl repository;

  const tHotelModel = HotelModel(
    id: 'HTL-KER-001',
    name: 'Grand Hyatt Kochi Bolgatty',
    destination: 'Kochi',
    city: 'Kochi',
    state: 'Kerala',
    starRating: 5,
    address: 'Bolgatty Island',
    rating: 4.8,
    reviewCount: 842,
    pricePerNight: 9499.0,
    images: ['https://hotel.com/1.jpg'],
    description: 'Luxury waterfront stay',
    amenities: [],
    rooms: [],
    cancellationPolicy: 'Free cancellation',
    latitude: 9.98,
    longitude: 76.26,
  );

  setUp(() {
    mockRemoteDataSource = MockHotelRemoteDataSource();
    mockLocalDataSource = MockHotelLocalDataSource();
    repository = HotelRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('HotelRepositoryImpl', () {
    test('returns remote hotels on success and caches them', () async {
      when(() => mockRemoteDataSource.getHotels(
            search: any(named: 'search'),
            destination: any(named: 'destination'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            rating: any(named: 'rating'),
            sort: any(named: 'sort'),
          )).thenAnswer((_) async => [tHotelModel]);
      when(() => mockLocalDataSource.cacheHotels(any())).thenAnswer((_) async {});

      final result = await repository.getHotels();

      expect(result.failure, isNull);
      expect(result.hotels?.length, 1);
      verify(() => mockLocalDataSource.cacheHotels([tHotelModel])).called(1);
    });

    test('falls back to local cache when remote call fails with NetworkException', () async {
      when(() => mockRemoteDataSource.getHotels(
            search: any(named: 'search'),
            destination: any(named: 'destination'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            rating: any(named: 'rating'),
            sort: any(named: 'sort'),
          )).thenThrow(const NetworkException(message: 'Connection timed out'));
      when(() => mockLocalDataSource.getCachedHotels()).thenAnswer((_) async => [tHotelModel]);

      final result = await repository.getHotels();

      expect(result.failure, isNull);
      expect(result.hotels?.length, 1);
      expect(result.hotels?.first.id, 'HTL-KER-001');
      verify(() => mockLocalDataSource.getCachedHotels()).called(1);
    });

    test('returns NetworkFailure when remote fails and cache is empty', () async {
      when(() => mockRemoteDataSource.getHotels(
            search: any(named: 'search'),
            destination: any(named: 'destination'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            rating: any(named: 'rating'),
            sort: any(named: 'sort'),
          )).thenThrow(const NetworkException(message: 'No internet'));
      when(() => mockLocalDataSource.getCachedHotels()).thenAnswer((_) async => []);

      final result = await repository.getHotels();

      expect(result.hotels, isNull);
      expect(result.failure, isA<NetworkFailure>());
    });
  });
}
