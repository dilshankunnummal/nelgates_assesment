import '../../../../core/network/api_client.dart';
import '../../../../core/utils/safe_parser.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getBookings();
  Future<BookingModel> createBooking(BookingModel booking);
  Future<BookingModel> cancelBooking(String bookingId, String reason);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<BookingModel>> getBookings() async {
    final response = await apiClient.get('/bookings');
    final data = SafeParser.toMap(response.data);
    final rawList = data['bookings'];
    return SafeParser.toList<BookingModel>(
      rawList,
      (item) => BookingModel.fromJson(SafeParser.toMap(item)),
    );
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    final response = await apiClient.post('/bookings', data: booking.toJson());
    final data = SafeParser.toMap(response.data);
    final bookingMap = SafeParser.toMap(data['booking']);
    return BookingModel.fromJson(bookingMap.isNotEmpty ? bookingMap : booking.toJson());
  }

  @override
  Future<BookingModel> cancelBooking(String bookingId, String reason) async {
    final response = await apiClient.patch(
      '/bookings/$bookingId/cancel',
      data: {'reason': reason},
    );
    final data = SafeParser.toMap(response.data);
    final bookingMap = SafeParser.toMap(data['booking']);
    return BookingModel.fromJson(bookingMap);
  }
}
