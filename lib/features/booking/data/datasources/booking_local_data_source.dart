import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/booking_model.dart';

abstract class BookingLocalDataSource {
  Future<List<BookingModel>> getBookings();
  Future<void> saveBooking(BookingModel booking);
  Future<void> updateBooking(BookingModel booking);
  Future<BookingModel?> getBookingById(String id);
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  final Box box;

  BookingLocalDataSourceImpl({required this.box});

  @override
  Future<List<BookingModel>> getBookings() async {
    try {
      final values = box.values;
      final list = <BookingModel>[];
      for (final val in values) {
        if (val is Map) {
          list.add(BookingModel.fromJson(Map<String, dynamic>.from(val)));
        }
      }

      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve bookings from local storage: $e');
    }
  }

  @override
  Future<void> saveBooking(BookingModel booking) async {
    try {
      await box.put(booking.id, booking.toJson());
    } catch (e) {
      throw CacheException(message: 'Failed to persist booking locally: $e');
    }
  }

  @override
  Future<void> updateBooking(BookingModel booking) async {
    try {
      await box.put(booking.id, booking.toJson());
    } catch (e) {
      throw CacheException(message: 'Failed to update booking locally: $e');
    }
  }

  @override
  Future<BookingModel?> getBookingById(String id) async {
    try {
      final raw = box.get(id);
      if (raw == null) return null;
      return BookingModel.fromJson(Map<String, dynamic>.from(raw as Map));
    } catch (e) {
      throw CacheException(message: 'Failed to get booking by ID: $e');
    }
  }
}
