import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/features/booking/data/models/booking_model.dart';

void main() {
  group('BookingModel', () {
    test('parses JSON correctly with full nested objects', () {
      final json = {
        'id': 'HTL-2026-X8K1L9',
        'hotel_id': 'HTL-KER-001',
        'hotel_name': 'Grand Hyatt Kochi Bolgatty',
        'hotel_image': 'https://hotel.com/hyatt.jpg',
        'hotel_address': 'Bolgatty Island, Kochi, Kerala',
        'room': {
          'id': 'RM-KER-001-1',
          'hotel_id': 'HTL-KER-001',
          'name': 'Grand Lake View Room',
          'description': 'Private balcony',
          'price_per_night': 9499.0,
          'capacity': 2,
          'bed_type': 'King Bed',
          'size_sq_ft': 450,
          'amenities': ['WiFi'],
          'is_available': true,
          'images': ['https://hotel.com/room.jpg'],
        },
        'check_in_date': '2026-09-10T14:00:00.000',
        'check_out_date': '2026-09-13T11:00:00.000',
        'nights': 3,
        'adults': 2,
        'children': 0,
        'rooms_count': 1,
        'base_room_price': 9499.0,
        'subtotal': 28497.0,
        'tax_amount': 3419.64,
        'service_charge_amount': 1424.85,
        'total_amount': 33341.49,
        'guest': {
          'first_name': 'Alex',
          'last_name': 'Mercer',
          'email': 'employee@hotel.com',
          'phone': '+91 9876543210',
          'special_requests': 'Quiet corner room',
        },
        'status': 'upcoming',
        'created_at': '2026-09-08T10:00:00.000',
      };

      final booking = BookingModel.fromJson(json);

      expect(booking.id, 'HTL-2026-X8K1L9');
      expect(booking.hotelName, 'Grand Hyatt Kochi Bolgatty');
      expect(booking.nights, 3);
      expect(booking.totalAmount, 33341.49);
      expect(booking.guest.fullName, 'Alex Mercer');
      expect(booking.isUpcoming, isTrue);
      expect(booking.isCancelled, isFalse);
    });

    test('toJson produces serializable Map with matching values', () {
      final json = {
        'id': 'HTL-2026-ABC123',
        'hotel_id': 'HTL-KAR-001',
        'hotel_name': 'The Leela Palace Bengaluru',
        'hotel_image': 'https://hotel.com/pic.jpg',
        'hotel_address': 'Old Airport Road, Bengaluru, Karnataka',
        'room': {
          'id': 'RM-2',
          'hotel_id': 'HTL-002',
          'name': 'Luxury Palace Room',
          'description': 'Lake view room',
          'price_per_night': 38000.0,
          'capacity': 2,
          'bed_type': 'King Bed',
          'size_sq_ft': 480,
          'amenities': [],
          'is_available': true,
          'images': [],
        },
        'check_in_date': '2026-09-15T00:00:00.000',
        'check_out_date': '2026-09-17T00:00:00.000',
        'nights': 2,
        'adults': 2,
        'children': 0,
        'rooms_count': 1,
        'base_room_price': 38000.0,
        'subtotal': 76000.0,
        'tax_amount': 9120.0,
        'service_charge_amount': 3800.0,
        'total_amount': 88920.0,
        'guest': {
          'first_name': 'Sarah',
          'last_name': 'Jenkins',
          'email': 'hr@hotel.com',
          'phone': '+91 9811223344',
        },
        'status': 'upcoming',
        'created_at': '2026-09-08T00:00:00.000',
      };

      final booking = BookingModel.fromJson(json);
      final serialized = booking.toJson();

      expect(serialized['id'], 'HTL-2026-ABC123');
      expect(serialized['total_amount'], 88920.0);
      expect(serialized['status'], 'upcoming');
    });
  });
}
