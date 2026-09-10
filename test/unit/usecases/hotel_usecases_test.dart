import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/core/error/failures.dart';
import 'package:nelegate_assessment/features/hotels/domain/entities/destination.dart';
import 'package:nelegate_assessment/features/hotels/domain/entities/hotel.dart';
import 'package:nelegate_assessment/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:nelegate_assessment/features/hotels/domain/usecases/hotel_usecases.dart';

class MockHotelRepository extends Mock implements HotelRepository {}

void main() {
  late MockHotelRepository mockRepository;
  late GetHotelsUseCase getHotelsUseCase;
  late GetHotelByIdUseCase getHotelByIdUseCase;
  late GetDestinationsUseCase getDestinationsUseCase;

  const tHotel = Hotel(
    id: 'HTL-KER-001',
    name: 'Grand Hyatt Kochi Bolgatty',
    destination: 'Kochi',
    city: 'Kochi',
    state: 'Kerala',
    starRating: 5,
    address: 'Bolgatty Island, Kochi',
    rating: 4.8,
    reviewCount: 842,
    pricePerNight: 9499.0,
    images: [],
    description: '',
    amenities: [],
    rooms: [],
    cancellationPolicy: '',
    latitude: 0,
    longitude: 0,
  );

  const tDestination = Destination(
    id: 'DST-KOC',
    name: 'Kochi',
    state: 'Kerala',
    country: 'India',
    image: '',
    hotelCount: 5,
    tagline: 'Island backwaters and heritage',
  );

  setUp(() {
    mockRepository = MockHotelRepository();
    getHotelsUseCase = GetHotelsUseCase(mockRepository);
    getHotelByIdUseCase = GetHotelByIdUseCase(mockRepository);
    getDestinationsUseCase = GetDestinationsUseCase(mockRepository);
  });

  group('Hotel Use Cases', () {
    test('GetHotelsUseCase delegates correctly to repository', () async {
      when(() => mockRepository.getHotels(
            search: 'Kochi',
            destination: null,
            minPrice: null,
            maxPrice: null,
            rating: null,
            sort: null,
          )).thenAnswer((_) async => (failure: null, hotels: [tHotel]));

      final result = await getHotelsUseCase(search: 'Kochi');

      expect(result.failure, isNull);
      expect(result.hotels?.length, 1);
      verify(() => mockRepository.getHotels(search: 'Kochi')).called(1);
    });

    test('GetHotelByIdUseCase returns hotel on success', () async {
      when(() => mockRepository.getHotelById('HTL-KER-001'))
          .thenAnswer((_) async => (failure: null, hotel: tHotel));

      final result = await getHotelByIdUseCase('HTL-KER-001');

      expect(result.failure, isNull);
      expect(result.hotel?.id, 'HTL-KER-001');
      verify(() => mockRepository.getHotelById('HTL-KER-001')).called(1);
    });

    test('GetHotelByIdUseCase propagates failure', () async {
      when(() => mockRepository.getHotelById('HTL-999')).thenAnswer(
        (_) async => (failure: const ServerFailure('Not found', statusCode: 404), hotel: null),
      );

      final result = await getHotelByIdUseCase('HTL-999');

      expect(result.hotel, isNull);
      expect(result.failure, isA<ServerFailure>());
    });

    test('GetDestinationsUseCase returns list of destinations', () async {
      when(() => mockRepository.getDestinations())
          .thenAnswer((_) async => (failure: null, destinations: [tDestination]));

      final result = await getDestinationsUseCase();

      expect(result.destinations?.length, 1);
      expect(result.destinations?.first.name, 'Kochi');
    });
  });
}
