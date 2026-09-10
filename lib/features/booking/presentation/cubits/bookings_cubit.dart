import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/booking_usecases.dart';

abstract class BookingsState extends Equatable {
  final List<Booking> allBookings;
  const BookingsState({this.allBookings = const []});

  List<Booking> get upcomingBookings =>
      allBookings.where((b) => b.status.toLowerCase() == 'upcoming').toList();

  List<Booking> get completedBookings =>
      allBookings.where((b) => b.status.toLowerCase() == 'completed').toList();

  List<Booking> get cancelledBookings =>
      allBookings.where((b) => b.status.toLowerCase() == 'cancelled').toList();

  @override
  List<Object?> get props => [allBookings];
}

class BookingsInitial extends BookingsState {
  const BookingsInitial();
}

class BookingsLoading extends BookingsState {
  const BookingsLoading({super.allBookings});
}

class BookingsLoaded extends BookingsState {
  const BookingsLoaded({required super.allBookings});
}

class BookingsEmpty extends BookingsState {
  const BookingsEmpty() : super(allBookings: const []);
}

class BookingsFailure extends BookingsState {
  final String message;
  const BookingsFailure({required this.message, super.allBookings});

  @override
  List<Object?> get props => [message, allBookings];
}

class BookingsCubit extends Cubit<BookingsState> {
  final GetBookingsUseCase getBookingsUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  BookingsCubit({
    required this.getBookingsUseCase,
    required this.cancelBookingUseCase,
  }) : super(const BookingsInitial());

  Future<void> loadBookings() async {
    emit(BookingsLoading(allBookings: state.allBookings));

    final result = await getBookingsUseCase();

    if (result.failure != null) {
      emit(BookingsFailure(message: result.failure!.message, allBookings: state.allBookings));
      return;
    }

    final bookings = result.bookings ?? [];
    if (bookings.isEmpty) {
      emit(const BookingsEmpty());
    } else {
      emit(BookingsLoaded(allBookings: bookings));
    }
  }

  Future<bool> cancelBooking(String bookingId, [String reason = 'Customer requested cancellation']) async {
    final result = await cancelBookingUseCase(bookingId: bookingId, reason: reason);

    if (result.failure != null) {
      emit(BookingsFailure(message: result.failure!.message, allBookings: state.allBookings));
      return false;
    }

    if (result.booking != null) {
      final updatedList = state.allBookings.map((b) {
        return b.id == bookingId ? result.booking! : b;
      }).toList();
      emit(BookingsLoaded(allBookings: updatedList));
      return true;
    }

    return false;
  }
}
