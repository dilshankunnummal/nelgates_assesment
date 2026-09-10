import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/core/error/failures.dart';
import 'package:nelegate_assessment/features/booking/domain/entities/booking.dart';
import 'package:nelegate_assessment/features/booking/domain/entities/guest.dart';
import 'package:nelegate_assessment/features/booking/domain/usecases/booking_usecases.dart';
import 'package:nelegate_assessment/features/booking/presentation/cubits/booking_cubit.dart';
import 'package:nelegate_assessment/features/hotels/domain/entities/hotel.dart';
import 'package:nelegate_assessment/features/hotels/domain/entities/room.dart';

class MockCreateBookingUseCase extends Mock implements CreateBookingUseCase {}

void main() {
  late MockCreateBookingUseCase mockCreateBookingUseCase;
  late BookingCubit bookingCubit;

  const tRoom = Room(
    id: 'RM-001',
    hotelId: 'HTL-001',
    name: 'Deluxe Room',
    description: 'Ocean view',
    pricePerNight: 2000.0,
    capacity: 2,
    bedType: 'King Bed',
    sizeSqFt: 400,
    amenities: [],
    isAvailable: true,
    images: [],
  );

  const tHotel = Hotel(
    id: 'HTL-KER-001',
    name: 'Grand Hyatt Kochi Bolgatty',
    destination: 'Kochi',
    city: 'Kochi',
    state: 'Kerala',
    starRating: 5,
    address: 'Bolgatty Island',
    rating: 4.8,
    reviewCount: 100,
    pricePerNight: 2000.0,
    images: [],
    description: 'Waterfront luxury stay',
    amenities: [],
    rooms: [tRoom],
    cancellationPolicy: 'Free cancellation',
    latitude: 9.98,
    longitude: 76.26,
  );

  const tGuest = Guest(
    firstName: 'Alex',
    lastName: 'Mercer',
    email: 'employee@hotel.com',
    phone: '+91 9876543210',
  );

  setUpAll(() {
    registerFallbackValue(Booking(
      id: 'dummy',
      hotelId: 'HTL-001',
      hotelName: 'Grand Hotel',
      hotelImage: '',
      hotelAddress: '',
      room: tRoom,
      checkInDate: DateTime.now(),
      checkOutDate: DateTime.now().add(const Duration(days: 1)),
      nights: 1,
      adults: 2,
      children: 0,
      roomsCount: 1,
      baseRoomPrice: 2000.0,
      subtotal: 2000.0,
      taxAmount: 240.0,
      serviceChargeAmount: 100.0,
      totalAmount: 2340.0,
      guest: tGuest,
      status: 'upcoming',
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockCreateBookingUseCase = MockCreateBookingUseCase();
    bookingCubit = BookingCubit(createBookingUseCase: mockCreateBookingUseCase);
  });

  tearDown(() {
    bookingCubit.close();
  });

  group('BookingCubit', () {
    test('initial state is BookingInitial', () {
      expect(bookingCubit.state, const BookingInitial());
    });

    blocTest<BookingCubit, BookingState>(
      'initBooking initializes draft with calculation',
      build: () => bookingCubit,
      act: (cubit) => cubit.initBooking(
        hotel: tHotel,
        room: tRoom,
        checkIn: DateTime(2026, 9, 10),
        checkOut: DateTime(2026, 9, 13), // 3 nights
      ),
      expect: () => [
        isA<BookingConfiguring>().having(
          (s) => s.draft?.nights,
          'nights',
          3,
        ),
      ],
    );

    blocTest<BookingCubit, BookingState>(
      'updates guest details and calculates correct subtotal',
      build: () => bookingCubit,
      act: (cubit) {
        cubit.initBooking(
          hotel: tHotel,
          room: tRoom,
          checkIn: DateTime(2026, 9, 10),
          checkOut: DateTime(2026, 9, 13), // 3 nights
        );
        cubit.updateGuests(roomsCount: 2); // 2 rooms * 3 nights * 2000 = 12000
        cubit.updateGuestDetails(tGuest);
      },
      verify: (cubit) {
        final draft = cubit.state.draft!;
        expect(draft.priceBreakdown.subtotal, 12000.0);
        expect(draft.guest, tGuest);
      },
    );

    blocTest<BookingCubit, BookingState>(
      'confirmBooking emits [BookingSubmitting, BookingConfirmed] on success',
      build: () {
        when(() => mockCreateBookingUseCase(any())).thenAnswer((invocation) async {
          final booking = invocation.positionalArguments[0] as Booking;
          return (failure: null, booking: booking);
        });
        return bookingCubit;
      },
      seed: () => BookingConfiguring(
        draft: BookingDraft(
          hotel: tHotel,
          room: tRoom,
          checkIn: DateTime(2026, 9, 10),
          checkOut: DateTime(2026, 9, 12),
          guest: tGuest,
        ),
      ),
      act: (cubit) => cubit.confirmBooking(),
      expect: () => [
        isA<BookingSubmitting>(),
        isA<BookingConfirmed>().having((s) => s.booking.status, 'status', 'upcoming'),
      ],
    );

    blocTest<BookingCubit, BookingState>(
      'confirmBooking emits [BookingSubmitting, BookingFailure] on failure',
      build: () {
        when(() => mockCreateBookingUseCase(any())).thenAnswer((_) async => (
              failure: const ServerFailure('Booking failed'),
              booking: null,
            ));
        return bookingCubit;
      },
      seed: () => BookingConfiguring(
        draft: BookingDraft(
          hotel: tHotel,
          room: tRoom,
          checkIn: DateTime(2026, 9, 10),
          checkOut: DateTime(2026, 9, 12),
          guest: tGuest,
        ),
      ),
      act: (cubit) => cubit.confirmBooking(),
      expect: () => [
        isA<BookingSubmitting>(),
        isA<BookingFailure>().having((s) => s.message, 'error message', 'Booking failed'),
      ],
    );
  });
}
