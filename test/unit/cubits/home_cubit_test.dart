import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/core/error/failures.dart';
import 'package:nelegate_assessment/features/hotels/domain/entities/destination.dart';
import 'package:nelegate_assessment/features/hotels/domain/entities/hotel.dart';
import 'package:nelegate_assessment/features/hotels/domain/usecases/hotel_usecases.dart';
import 'package:nelegate_assessment/features/hotels/presentation/cubits/home_cubit.dart';

class MockGetDestinationsUseCase extends Mock implements GetDestinationsUseCase {}
class MockGetHotelsUseCase extends Mock implements GetHotelsUseCase {}

void main() {
  late MockGetDestinationsUseCase mockGetDestinationsUseCase;
  late MockGetHotelsUseCase mockGetHotelsUseCase;
  late HomeCubit homeCubit;

  const tDestination = Destination(
    id: 'DST-BLR',
    name: 'Bengaluru',
    state: 'Karnataka',
    country: 'India',
    image: 'https://example.com/blr.jpg',
    hotelCount: 1, // Stale count
    tagline: 'Tech capital',
  );

  const tHotels = [
    Hotel(
      id: 'HTL-KAR-001',
      name: 'The Leela Palace Bengaluru',
      destination: 'Bengaluru',
      city: 'Bengaluru',
      state: 'Karnataka',
      starRating: 5,
      address: 'Old Airport Road',
      rating: 4.9,
      reviewCount: 1250,
      pricePerNight: 15499.0,
      images: [],
      description: 'Luxury',
      amenities: [],
      rooms: [],
      cancellationPolicy: 'Free',
      latitude: 12.96,
      longitude: 77.64,
    ),
    Hotel(
      id: 'HTL-KAR-007',
      name: 'ITC Gardenia',
      destination: 'Bengaluru',
      city: 'Bengaluru',
      state: 'Karnataka',
      starRating: 5,
      address: 'Residency Road',
      rating: 4.8,
      reviewCount: 1140,
      pricePerNight: 14200.0,
      images: [],
      description: 'Luxury Collection',
      amenities: [],
      rooms: [],
      cancellationPolicy: 'Free',
      latitude: 12.96,
      longitude: 77.59,
    ),
  ];

  setUp(() {
    mockGetDestinationsUseCase = MockGetDestinationsUseCase();
    mockGetHotelsUseCase = MockGetHotelsUseCase();
    homeCubit = HomeCubit(
      getDestinationsUseCase: mockGetDestinationsUseCase,
      getHotelsUseCase: mockGetHotelsUseCase,
    );
  });

  tearDown(() {
    homeCubit.close();
  });

  group('HomeCubit Tests', () {
    test('initial state is HomeInitial', () {
      expect(homeCubit.state, equals(const HomeInitial()));
    });

    test('loadHomeData emits [HomeLoading, HomeLoaded] and dynamically synchronizes destination hotel count', () async {
      when(() => mockGetDestinationsUseCase()).thenAnswer(
        (_) async => (failure: null, destinations: [tDestination]),
      );
      when(() => mockGetHotelsUseCase()).thenAnswer(
        (_) async => (failure: null, hotels: tHotels),
      );

      final expectedStates = [
        const HomeLoading(),
        isA<HomeLoaded>().having(
          (s) => s.destinations.first.hotelCount,
          'hotelCount matches live hotel list count (2 for Bengaluru)',
          2,
        ),
      ];

      expectLater(homeCubit.stream, emitsInOrder(expectedStates));

      await homeCubit.loadHomeData();
    });

    test('loadHomeData emits HomeError when both use cases fail', () async {
      when(() => mockGetDestinationsUseCase()).thenAnswer(
        (_) async => (failure: const ServerFailure('Server error'), destinations: null),
      );
      when(() => mockGetHotelsUseCase()).thenAnswer(
        (_) async => (failure: const ServerFailure('Server error'), hotels: null),
      );

      final expectedStates = [
        const HomeLoading(),
        const HomeError('Server error'),
      ];

      expectLater(homeCubit.stream, emitsInOrder(expectedStates));

      await homeCubit.loadHomeData();
    });
  });
}
