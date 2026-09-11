import '../../../../core/config/app_environment.dart';
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
      try {

        final remoteBookings = await remoteDataSource.getBookings();
        if (remoteBookings.isNotEmpty) {
          for (final b in remoteBookings) {
            await localDataSource.saveBooking(b);
          }
          return (failure: null, bookings: remoteBookings);
        }
      } catch (e) {

      }

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

      if (AppEnvironment.isFirebase) {
        try {
          await remoteDataSource.createBooking(bookingModel);
        } on ServerException catch (e) {
          return (failure: ServerFailure(e.message), booking: null);
        } catch (e) {
          return (failure: UnknownFailure(e.toString()), booking: null);
        }
      }

      await localDataSource.saveBooking(bookingModel);

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

      if (AppEnvironment.isFirebase) {
        try {
          await remoteDataSource.cancelBooking(bookingId, reason);
        } on ServerException catch (e) {
          return (failure: ServerFailure(e.message), booking: null);
        } catch (e) {
          return (failure: UnknownFailure(e.toString()), booking: null);
        }
      }

      final existing = await localDataSource.getBookingById(bookingId);
      if (existing != null) {
        final updated = existing.copyWith(
          status: 'cancelled',
          cancellationReason: reason,
        );
        final updatedModel = BookingModel.fromEntity(updated);
        await localDataSource.saveBooking(updatedModel);
        return (failure: null, booking: updatedModel);
      }

      return (failure: null, booking: null);
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
