import '../../../../core/error/failures.dart';
import '../../domain/entities/booking.dart';

abstract class BookingRepository {
  Future<({Failure? failure, List<Booking>? bookings})> getBookings();

  Future<({Failure? failure, Booking? booking})> createBooking(Booking booking);

  Future<({Failure? failure, Booking? booking})> cancelBooking({
    required String bookingId,
    required String reason,
  });

  Future<({Failure? failure, Booking? booking})> getBookingById(String id);
}
