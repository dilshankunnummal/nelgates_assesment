import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/core/error/failures.dart';
import 'package:nelegate_assessment/features/hotels/domain/entities/hotel.dart';
import 'package:nelegate_assessment/features/hotels/domain/usecases/hotel_usecases.dart';
import 'package:nelegate_assessment/features/hotels/presentation/cubits/hotel_search_cubit.dart';

class MockGetHotelsUseCase extends Mock implements GetHotelsUseCase {}

void main() {
  late MockGetHotelsUseCase mockGetHotelsUseCase;
  late HotelSearchCubit searchCubit;

  const tHotel = Hotel(
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
    description: 'Luxury stay',
    amenities: [],
    rooms: [],
    cancellationPolicy: 'Free cancellation',
    latitude: 9.98,
    longitude: 76.26,
  );

  setUp(() {
    mockGetHotelsUseCase = MockGetHotelsUseCase();
    searchCubit = HotelSearchCubit(getHotelsUseCase: mockGetHotelsUseCase);
  });

  tearDown(() {
    searchCubit.close();
  });

  group('HotelSearchCubit', () {
    test('initial state is HotelSearchInitial', () {
      expect(searchCubit.state, isA<HotelSearchInitial>());
    });

    blocTest<HotelSearchCubit, HotelSearchState>(
      'emits [HotelSearchLoading, HotelSearchSuccess] when search yields results',
      build: () {
        when(() => mockGetHotelsUseCase(
              search: any(named: 'search'),
              destination: any(named: 'destination'),
              minPrice: any(named: 'minPrice'),
              maxPrice: any(named: 'maxPrice'),
              rating: any(named: 'rating'),
              sort: any(named: 'sort'),
            )).thenAnswer((_) async => (failure: null, hotels: [tHotel]));
        return searchCubit;
      },
      act: (cubit) => cubit.searchHotels(),
      expect: () => [
        isA<HotelSearchLoading>(),
        isA<HotelSearchSuccess>().having((s) => s.hotels.length, 'hotels length', 1),
      ],
    );

    blocTest<HotelSearchCubit, HotelSearchState>(
      'emits [HotelSearchLoading, HotelSearchEmpty] when no results match',
      build: () {
        when(() => mockGetHotelsUseCase(
              search: any(named: 'search'),
              destination: any(named: 'destination'),
              minPrice: any(named: 'minPrice'),
              maxPrice: any(named: 'maxPrice'),
              rating: any(named: 'rating'),
              sort: any(named: 'sort'),
            )).thenAnswer((_) async => (failure: null, hotels: <Hotel>[]));
        return searchCubit;
      },
      act: (cubit) => cubit.searchHotels(),
      expect: () => [
        isA<HotelSearchLoading>(),
        isA<HotelSearchEmpty>(),
      ],
    );

    blocTest<HotelSearchCubit, HotelSearchState>(
      'emits [HotelSearchLoading, HotelSearchFailure] on network error',
      build: () {
        when(() => mockGetHotelsUseCase(
              search: any(named: 'search'),
              destination: any(named: 'destination'),
              minPrice: any(named: 'minPrice'),
              maxPrice: any(named: 'maxPrice'),
              rating: any(named: 'rating'),
              sort: any(named: 'sort'),
            )).thenAnswer((_) async => (
              failure: const NetworkFailure('Failed to connect'),
              hotels: null,
            ));
        return searchCubit;
      },
      act: (cubit) => cubit.searchHotels(),
      expect: () => [
        isA<HotelSearchLoading>(),
        isA<HotelSearchFailure>().having((s) => s.message, 'error message', 'Failed to connect'),
      ],
    );
  });
}
