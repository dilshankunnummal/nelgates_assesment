import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/core/error/failures.dart';
import 'package:nelegate_assessment/features/hotels/domain/entities/hotel.dart';
import 'package:nelegate_assessment/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:nelegate_assessment/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:nelegate_assessment/features/wishlist/presentation/cubit/wishlist_state.dart';

class MockGetWishlistUseCase extends Mock implements GetWishlistUseCase {}
class MockToggleWishlistUseCase extends Mock implements ToggleWishlistUseCase {}

void main() {
  late MockGetWishlistUseCase mockGetWishlistUseCase;
  late MockToggleWishlistUseCase mockToggleWishlistUseCase;
  late WishlistCubit wishlistCubit;

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
    mockGetWishlistUseCase = MockGetWishlistUseCase();
    mockToggleWishlistUseCase = MockToggleWishlistUseCase();
    wishlistCubit = WishlistCubit(
      getWishlistUseCase: mockGetWishlistUseCase,
      toggleWishlistUseCase: mockToggleWishlistUseCase,
    );
  });

  tearDown(() {
    wishlistCubit.close();
  });

  group('WishlistCubit', () {
    test('initial state is WishlistInitial', () {
      expect(wishlistCubit.state, const WishlistInitial());
    });

    blocTest<WishlistCubit, WishlistState>(
      'loads wishlist successfully',
      build: () {
        when(() => mockGetWishlistUseCase()).thenAnswer((_) async => (failure: null, hotels: [tHotel]));
        return wishlistCubit;
      },
      act: (cubit) => cubit.loadWishlist(),
      expect: () => [
        const WishlistLoading(items: []),
        const WishlistLoaded(items: [tHotel]),
      ],
    );

    blocTest<WishlistCubit, WishlistState>(
      'optimistically adds hotel to wishlist when not already added',
      build: () {
        when(() => mockToggleWishlistUseCase(tHotel)).thenAnswer((_) async => (failure: null, isWishlisted: true));
        return wishlistCubit;
      },
      act: (cubit) => cubit.toggleWishlist(tHotel),
      expect: () => [
        const WishlistLoaded(items: [tHotel]),
      ],
    );

    blocTest<WishlistCubit, WishlistState>(
      'rolls back optimistic update when toggle fails',
      build: () {
        when(() => mockToggleWishlistUseCase(tHotel)).thenAnswer((_) async => (
              failure: const CacheFailure('Disk write failed'),
              isWishlisted: false,
            ));
        return wishlistCubit;
      },
      act: (cubit) => cubit.toggleWishlist(tHotel),
      expect: () => [
        const WishlistLoaded(items: [tHotel]),
        const WishlistError(
          message: 'Failed to update wishlist. Rolling back changes.',
          items: [],
        ),
      ],
    );
  });
}
