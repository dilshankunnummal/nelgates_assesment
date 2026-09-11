import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/booking_model.dart';
import 'booking_remote_data_source.dart';

class FirebaseBookingDataSourceImpl implements BookingRemoteDataSource {
  FirebaseFirestore? _firestore;

  FirebaseBookingDataSourceImpl({this._firestore});

  FirebaseFirestore get _db => _firestore ??= FirebaseFirestore.instance;

  @override
  Future<List<BookingModel>> getBookings() async {
    try {
      AppLogger.firebase('Querying bookings collection from Firestore...');
      final snapshot = await _db
          .collection('bookings')
          .orderBy('created_at', descending: true)
          .get(const GetOptions(source: Source.serverAndCache));

      final bookings = snapshot.docs.map((doc) => BookingModel.fromJson(doc.data())).toList();
      AppLogger.firebase('Fetched ${bookings.length} bookings from Firestore.', isSuccess: true);
      return bookings;
    } catch (e) {
      AppLogger.warning('Direct ordered bookings query notice, trying unordered fallback: $e', tag: 'BOOKINGS 📋');
      try {
        final snapshot = await _db.collection('bookings').get();
        final bookings = snapshot.docs.map((doc) => BookingModel.fromJson(doc.data())).toList();
        AppLogger.firebase('Fallback fetched ${bookings.length} bookings.', isSuccess: true);
        return bookings;
      } catch (innerError) {
        AppLogger.firebase('Failed to fetch bookings from Firestore', error: innerError);
        throw ServerException(message: 'Failed to fetch bookings from Firebase: $innerError');
      }
    }
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      AppLogger.firebase('Creating booking ID: ${booking.id} for Hotel: ${booking.hotelName} (Amount: \$${booking.totalAmount})...');
      final docRef = _db.collection('bookings').doc(booking.id);
      final json = booking.toJson();
      await docRef.set(json, SetOptions(merge: true));
      AppLogger.firebase('Booking created successfully in Firestore: ${booking.id}', isSuccess: true);
      return booking;
    } catch (e) {
      AppLogger.firebase('Failed to write booking ${booking.id} to Firestore', error: e);
      throw ServerException(message: 'Failed to create booking in Firebase: $e');
    }
  }

  @override
  Future<BookingModel> cancelBooking(String bookingId, String reason) async {
    try {
      AppLogger.firebase('Cancelling booking ID: $bookingId with reason: "$reason"...');
      final docRef = _db.collection('bookings').doc(bookingId);
      final doc = await docRef.get();
      if (!doc.exists || doc.data() == null) {
        AppLogger.error('Booking $bookingId not found for cancellation', tag: 'BOOKINGS 📋');
        throw ServerException(message: 'Booking not found with ID: $bookingId');
      }

      await docRef.update({
        'status': 'cancelled',
        'cancellation_reason': reason,
        'updated_at': FieldValue.serverTimestamp(),
      });

      final updatedData = (await docRef.get()).data()!;
      AppLogger.firebase('Booking $bookingId cancelled successfully in Firestore.', isSuccess: true);
      return BookingModel.fromJson(updatedData);
    } catch (e) {
      AppLogger.firebase('Failed to cancel booking $bookingId', error: e);
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Failed to cancel booking: $e');
    }
  }
}
