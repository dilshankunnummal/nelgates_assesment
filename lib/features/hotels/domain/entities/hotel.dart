import 'package:equatable/equatable.dart';
import 'amenity.dart';
import 'room.dart';

class Hotel extends Equatable {
  final String id;
  final String name;
  final String destination;
  final String city;
  final String address;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final double? originalPrice;
  final List<String> images;
  final String description;
  final List<Amenity> amenities;
  final List<Room> rooms;
  final String cancellationPolicy;
  final String state;
  final int starRating;
  final double latitude;
  final double longitude;
  final bool isPopular;
  final bool isFeatured;

  const Hotel({
    required this.id,
    required this.name,
    required this.destination,
    required this.city,
    this.state = 'Kerala',
    this.starRating = 4,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    this.originalPrice,
    required this.images,
    required this.description,
    required this.amenities,
    required this.rooms,
    required this.cancellationPolicy,
    required this.latitude,
    required this.longitude,
    this.isPopular = false,
    this.isFeatured = false,
  });

  String get mainImage => images.isNotEmpty ? images.first : '';

  @override
  List<Object?> get props => [
        id,
        name,
        destination,
        city,
        state,
        starRating,
        address,
        rating,
        reviewCount,
        pricePerNight,
        originalPrice,
        images,
        description,
        amenities,
        rooms,
        cancellationPolicy,
        latitude,
        longitude,
        isPopular,
        isFeatured,
      ];
}
