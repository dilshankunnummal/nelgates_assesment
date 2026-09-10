import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/features/hotels/data/models/hotel_model.dart';

void main() {
  group('HotelModel', () {
    test('parses standard JSON correctly', () {
      final json = {
        'id': 'HTL-101',
        'name': 'The Royal Oasis',
        'destination': 'Kochi',
        'city': 'Kochi',
        'state': 'Kerala',
        'star_rating': 5,
        'address': 'Marine Drive',
        'rating': 4.8,
        'review_count': 250,
        'price_per_night': 8500.0,
        'original_price': 10000.0,
        'images': ['https://hotel.com/oasis.jpg'],
        'description': 'A luxury beachside resort.',
        'amenities': [
          {'id': 'a1', 'name': 'Free WiFi', 'icon': 'wifi'}
        ],
        'rooms': [
          {
            'id': 'RM-1',
            'hotel_id': 'HTL-101',
            'name': 'Deluxe Room',
            'price_per_night': 8500.0,
            'capacity': 2,
            'bed_type': 'King Bed',
            'size_sq_ft': 400,
            'amenities': ['WiFi', 'AC'],
            'is_available': true,
            'images': ['https://hotel.com/room.jpg'],
          }
        ],
        'cancellation_policy': 'Free cancellation',
        'latitude': 15.29,
        'longitude': 73.91,
        'is_popular': true,
        'is_featured': true,
      };

      final hotel = HotelModel.fromJson(json);

      expect(hotel.id, 'HTL-101');
      expect(hotel.name, 'The Royal Oasis');
      expect(hotel.rating, 4.8);
      expect(hotel.pricePerNight, 8500.0);
      expect(hotel.rooms.length, 1);
      expect(hotel.amenities.length, 1);
      expect(hotel.isPopular, isTrue);
      expect(hotel.isFeatured, isTrue);
    });

    test('defensively parses missing and malformed fields with safe fallbacks', () {
      final malformedJson = {
        'id': null,
        'name': null,
        'rating': '4.5', // String numeric
        'price_per_night': '12,500', // String numeric with comma
        'images': {
          'large': 'https://hotel.com/nested.jpg', // Nested image Map
        },
        'amenities': ['WiFi', 'Pool'], // List of Strings instead of Maps
      };

      final hotel = HotelModel.fromJson(malformedJson);

      expect(hotel.id, isNotEmpty);
      expect(hotel.name, isNotEmpty);
      expect(hotel.rating, 4.5);
      expect(hotel.pricePerNight, 12500.0);
      expect(hotel.images.first, 'https://hotel.com/nested.jpg');
      expect(hotel.amenities.length, 2);
    });

    test('toJson serializes correctly', () {
      const hotel = HotelModel(
        id: 'HTL-999',
        name: 'Grand Test Hotel',
        destination: 'Bengaluru',
        city: 'Bengaluru',
        state: 'Karnataka',
        starRating: 5,
        address: 'MG Road',
        rating: 4.9,
        reviewCount: 150,
        pricePerNight: 20000.0,
        images: ['https://hotel.com/pic.jpg'],
        description: 'Test hotel description',
        amenities: [],
        rooms: [],
        cancellationPolicy: 'Free cancel',
        latitude: 18.9,
        longitude: 72.8,
      );

      final json = hotel.toJson();
      expect(json['id'], 'HTL-999');
      expect(json['name'], 'Grand Test Hotel');
      expect(json['price_per_night'], 20000.0);
    });
  });
}
