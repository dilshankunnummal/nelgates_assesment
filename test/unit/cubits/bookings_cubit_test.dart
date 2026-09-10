import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/features/booking/domain/entities/booking.dart';
import 'package:nelegate_assessment/features/booking/domain/entities/guest.dart';
import 'package:nelegate_assessment/features/booking/domain/usecases/booking_usecases.dart';
import 'package:nelegate_assessment/features/booking/presentation/cubits/bookings_cubit.dart';
import 'package:nelegate_assessment/features/hotels/domain/entities/room.dart';

class MockGetBookingsUseCase extends Mock implements GetBookingsUseCase {}
class MockCancelBookingUseCase extends Mock implements CancelBookingUseCase {}

void main() {
  late MockGetBookingsUseCase mockGetBookingsUseCase;
  late MockCancelBookingUseCase mockCancelBookingUseCase;
  late BookingsCubit bookingsCubit;

  final tBooking = Booking(
    id: 'HTL-2026-TEST01',
    hotelId: 'HTL-KER-001',
    hotelName: 'Grand Hyatt Kochi Bolgatty',
    hotelImage: '',
    hotelAddress: 'Bolgatty Island, Kochi, Kerala',
    room: const Room(
      id: 'RM-1',
      hotelId: 'HTL-001',
      name: 'Deluxe Room',
      description: '',
      pricePerNight: 10000.0,
      capacity: 2,
      bedType: 'King Bed',
      sizeSqFt: 500,
      amenities: [],
      isAvailable: true,
      images: [],
    ),
    checkInDate: DateTime(2026, 9, 10),
    checkOutDate: DateTime(2026, 9, 13),
    nights: 3,
    adults: 2,
    children: 0,
    roomsCount: 1,
    baseRoomPrice: 10000.0,
    subtotal: 30000.0,
    taxAmount: 3600.0,
    serviceChargeAmount: 1500.0,
    totalAmount: 35100.0,
    guest: const Guest(
      firstName: 'Alex',
      lastName: 'Mercer',
      email: 'employee@hotel.com',
      phone: '+91 9876543210',
    ),
    status: 'upcoming',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockGetBookingsUseCase = MockGetBookingsUseCase();
    mockCancelBookingUseCase = MockCancelBookingUseCase();
    bookingsCubit = BookingsCubit(
      getBookingsUseCase: mockGetBookingsUseCase,
      cancelBookingUseCase: mockCancelBookingUseCase,
    );
  });

  tearDown(() {
    bookingsCubit.close();
  });

  group('BookingsCubit', () {
    test('initial state is BookingsInitial', () {
      expect(bookingsCubit.state, const BookingsInitial());
    });

    blocTest<BookingsCubit, BookingsState>(
      'loads bookings successfully',
      build: () {
        when(() => mockGetBookingsUseCase()).thenAnswer((_) async => (
              failure: null,
              bookings: [tBooking],
            ));
        return bookingsCubit;
      },
      act: (cubit) => cubit.loadBookings(),
      expect: () => [
        const BookingsLoading(allBookings: []),
        BookingsLoaded(allBookings: [tBooking]),
      ],
    );

    blocTest<BookingsCubit, BookingsState>(
      'cancels booking and updates status in state',
      build: () {
        final cancelledBooking = tBooking.copyWith(status: 'cancelled');
        when(() => mockCancelBookingUseCase(
              bookingId: 'HTL-2026-TEST01',
              reason: any(named: 'reason'),
            )).thenAnswer((_) async => (failure: null, booking: cancelledBooking));
        return bookingsCubit;
      },
      seed: () => BookingsLoaded(allBookings: [tBooking]),
      act: (cubit) => cubit.cancelBooking('HTL-2026-TEST01'),
      expect: () => [
        isA<BookingsLoaded>().having(
          (s) => s.allBookings.first.status,
          'status',
          'cancelled',
        ),
      ],
    );
  });
}
