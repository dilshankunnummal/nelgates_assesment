import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/features/hotels/domain/entities/hotel.dart';
import 'package:nelegate_assessment/features/hotels/presentation/widgets/hotel_card.dart';
import 'package:nelegate_assessment/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:nelegate_assessment/features/wishlist/presentation/cubit/wishlist_state.dart';

class MockWishlistCubit extends Mock implements WishlistCubit {}

void main() {
  late MockWishlistCubit mockWishlistCubit;

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
    description: 'Waterfront luxury stay overlooking Vembanad lake',
    amenities: [],
    rooms: [],
    cancellationPolicy: 'Free cancellation',
    latitude: 9.98,
    longitude: 76.26,
  );

  setUp(() {
    mockWishlistCubit = MockWishlistCubit();
    when(() => mockWishlistCubit.state).thenReturn(const WishlistLoaded(items: []));
    when(() => mockWishlistCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('HotelCard displays hotel name, location, rating and price', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<WishlistCubit>.value(
            value: mockWishlistCubit,
            child: const HotelCard(hotel: tHotel),
          ),
        ),
      ),
    );

    expect(find.text('Grand Hyatt Kochi Bolgatty'), findsOneWidget);
    expect(find.text('Kochi, Kerala'), findsOneWidget);
    expect(find.text('4.8'), findsOneWidget);
    expect(find.text('842 reviews'), findsOneWidget);
  });
}
