import '../../../../core/error/failures.dart';
import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository _repository;
  const CreateBookingUseCase(this._repository);

  Future<({Failure? failure, Booking? booking})> call(Booking booking) {
    return _repository.createBooking(booking);
  }
}

class GetBookingsUseCase {
  final BookingRepository _repository;
  const GetBookingsUseCase(this._repository);

  Future<({Failure? failure, List<Booking>? bookings})> call() {
    return _repository.getBookings();
  }
}

class CancelBookingUseCase {
  final BookingRepository _repository;
  const CancelBookingUseCase(this._repository);

  Future<({Failure? failure, Booking? booking})> call({
    required String bookingId,
    required String reason,
  }) {
    return _repository.cancelBooking(bookingId: bookingId, reason: reason);
  }
}

class GetBookingByIdUseCase {
  final BookingRepository _repository;
  const GetBookingByIdUseCase(this._repository);

  Future<({Failure? failure, Booking? booking})> call(String id) {
    return _repository.getBookingById(id);
  }
}
