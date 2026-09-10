import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../models/booking_model.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_local_data_source.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final BookingLocalDataSource localDataSource;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<({Failure? failure, List<Booking>? bookings})> getBookings() async {
    try {
      // Local storage is primary source of truth for user bookings
      final localBookings = await localDataSource.getBookings();
      return (failure: null, bookings: localBookings);
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), bookings: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), bookings: null);
    }
  }

  @override
  Future<({Failure? failure, Booking? booking})> createBooking(Booking booking) async {
    try {
      final bookingModel = booking is BookingModel ? booking : BookingModel.fromEntity(booking);

      // Save locally first for guaranteed offline preservation
      await localDataSource.saveBooking(bookingModel);

      // Also dispatch to mock remote API
      try {
        await remoteDataSource.createBooking(bookingModel);
      } catch (_) {
        // Local persistence still succeeded
      }

      return (failure: null, booking: bookingModel);
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), booking: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), booking: null);
    }
  }

  @override
  Future<({Failure? failure, Booking? booking})> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    try {
      final existing = await localDataSource.getBookingById(bookingId);
      if (existing == null) {
        return (failure: const CacheFailure('Booking not found'), booking: null);
      }

      final updated = existing.copyWith(
        status: 'cancelled',
        cancellationReason: reason,
      );

      final updatedModel = BookingModel.fromEntity(updated);
      await localDataSource.updateBooking(updatedModel);

      try {
        await remoteDataSource.cancelBooking(bookingId, reason);
      } catch (_) {
        // Local update succeeded
      }

      return (failure: null, booking: updatedModel);
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), booking: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), booking: null);
    }
  }

  @override
  Future<({Failure? failure, Booking? booking})> getBookingById(String id) async {
    try {
      final booking = await localDataSource.getBookingById(id);
      if (booking != null) {
        return (failure: null, booking: booking);
      }
      return (failure: const CacheFailure('Booking not found'), booking: null);
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), booking: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), booking: null);
    }
  }
}
