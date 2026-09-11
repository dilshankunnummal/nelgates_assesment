import '../../../../core/utils/safe_parser.dart';
import '../../domain/entities/hotel.dart';
import 'amenity_model.dart';
import 'room_model.dart';

class HotelModel extends Hotel {
  const HotelModel({
    required super.id,
    required super.name,
    required super.destination,
    required super.city,
    super.state = 'Kerala',
    super.starRating = 4,
    required super.address,
    required super.rating,
    required super.reviewCount,
    required super.pricePerNight,
    super.originalPrice,
    required super.images,
    required super.description,
    required super.amenities,
    required super.rooms,
    required super.cancellationPolicy,
    required super.latitude,
    required super.longitude,
    super.isPopular = false,
    super.isFeatured = false,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {

    final rawImages = json['images'] ?? json['image'] ?? json['image_url'];
    final imagesList = SafeParser.toImageList(
      rawImages,
      fallback: const ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80'],
    );

    final rawAmenities = json['amenities'];
    final amenitiesList = SafeParser.toList<AmenityModel>(
      rawAmenities,
      (item) => AmenityModel.fromJson(item),
    );

    final rawRooms = json['rooms'];
    final roomsList = SafeParser.toList<RoomModel>(
      rawRooms,
      (item) => RoomModel.fromJson(SafeParser.toMap(item)),
    );

    return HotelModel(
      id: SafeParser.toStr(json['id'], fallback: 'HTL-001'),
      name: SafeParser.toStr(json['name'], fallback: 'Luxury Grand Hotel'),
      destination: SafeParser.toStr(json['destination'], fallback: 'Kochi'),
      city: SafeParser.toStr(json['city'], fallback: 'Kochi'),
      state: SafeParser.toStr(json['state'], fallback: 'Kerala'),
      starRating: SafeParser.toInt(json['star_rating'] ?? json['starRating'] ?? json['stars'], fallback: 4),
      address: SafeParser.toStr(json['address'], fallback: '12 Marine Drive'),
      rating: SafeParser.toDouble(json['rating'], fallback: 4.5),
      reviewCount: SafeParser.toInt(json['review_count'] ?? json['reviewCount'] ?? json['reviews'], fallback: 120),
      pricePerNight: SafeParser.toDouble(json['price_per_night'] ?? json['price'], fallback: 4500.0),
      originalPrice: json['original_price'] != null || json['originalPrice'] != null
          ? SafeParser.toDouble(json['original_price'] ?? json['originalPrice'])
          : null,
      images: imagesList,
      description: SafeParser.toStr(
        json['description'],
        fallback: 'Experience unmatched luxury with scenic views, world-class amenities, and exquisite dining.',
      ),
      amenities: amenitiesList,
      rooms: roomsList,
      cancellationPolicy: SafeParser.toStr(
        json['cancellation_policy'] ?? json['cancellationPolicy'],
        fallback: 'Free cancellation up to 48 hours before check-in. Non-refundable afterwards.',
      ),
      latitude: SafeParser.toDouble(json['latitude'] ?? json['lat'], fallback: 9.9312),
      longitude: SafeParser.toDouble(json['longitude'] ?? json['lng'], fallback: 76.2673),
      isPopular: SafeParser.toBool(json['is_popular'] ?? json['isPopular'], fallback: false),
      isFeatured: SafeParser.toBool(json['is_featured'] ?? json['isFeatured'], fallback: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'destination': destination,
      'city': city,
      'state': state,
      'star_rating': starRating,
      'address': address,
      'rating': rating,
      'review_count': reviewCount,
      'price_per_night': pricePerNight,
      'original_price': originalPrice,
      'images': images,
      'description': description,
      'amenities': amenities.map((a) => (a is AmenityModel) ? a.toJson() : AmenityModel.fromEntity(a).toJson()).toList(),
      'rooms': rooms.map((r) => (r is RoomModel) ? r.toJson() : RoomModel.fromEntity(r).toJson()).toList(),
      'cancellation_policy': cancellationPolicy,
      'latitude': latitude,
      'longitude': longitude,
      'is_popular': isPopular,
      'is_featured': isFeatured,
    };
  }

  factory HotelModel.fromEntity(Hotel entity) {
    return HotelModel(
      id: entity.id,
      name: entity.name,
      destination: entity.destination,
      city: entity.city,
      state: entity.state,
      starRating: entity.starRating,
      address: entity.address,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      pricePerNight: entity.pricePerNight,
      originalPrice: entity.originalPrice,
      images: entity.images,
      description: entity.description,
      amenities: entity.amenities,
      rooms: entity.rooms,
      cancellationPolicy: entity.cancellationPolicy,
      latitude: entity.latitude,
      longitude: entity.longitude,
      isPopular: entity.isPopular,
      isFeatured: entity.isFeatured,
    );
  }
}
