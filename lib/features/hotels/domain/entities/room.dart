import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String id;
  final String hotelId;
  final String name; // e.g. "Deluxe Ocean Suite"
  final String description;
  final double pricePerNight;
  final int capacity; // max adults
  final String bedType; // e.g. "King Bed"
  final int sizeSqFt;
  final List<String> amenities;
  final bool isAvailable;
  final List<String> images;

  const Room({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.description,
    required this.pricePerNight,
    required this.capacity,
    required this.bedType,
    required this.sizeSqFt,
    required this.amenities,
    required this.isAvailable,
    required this.images,
  });

  String get mainImage => images.isNotEmpty ? images.first : '';

  @override
  List<Object?> get props => [
        id,
        hotelId,
        name,
        description,
        pricePerNight,
        capacity,
        bedType,
        sizeSqFt,
        amenities,
        isAvailable,
        images,
      ];
}
