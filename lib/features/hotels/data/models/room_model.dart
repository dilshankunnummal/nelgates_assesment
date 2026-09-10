import '../../../../core/utils/safe_parser.dart';
import '../../domain/entities/room.dart';

class RoomModel extends Room {
  const RoomModel({
    required super.id,
    required super.hotelId,
    required super.name,
    required super.description,
    required super.pricePerNight,
    required super.capacity,
    required super.bedType,
    required super.sizeSqFt,
    required super.amenities,
    required super.isAvailable,
    required super.images,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: SafeParser.toStr(json['id'], fallback: 'RM-001'),
      hotelId: SafeParser.toStr(json['hotel_id'] ?? json['hotelId'], fallback: 'HTL-001'),
      name: SafeParser.toStr(json['name'] ?? json['room_type'], fallback: 'Standard Room'),
      description: SafeParser.toStr(
        json['description'],
        fallback: 'Comfortable guest room with contemporary furnishing and premium bedding.',
      ),
      pricePerNight: SafeParser.toDouble(json['price_per_night'] ?? json['price'], fallback: 2000.0),
      capacity: SafeParser.toInt(json['capacity'] ?? json['max_guests'], fallback: 2),
      bedType: SafeParser.toStr(json['bed_type'] ?? json['bedType'], fallback: 'King Bed'),
      sizeSqFt: SafeParser.toInt(json['size_sq_ft'] ?? json['sizeSqFt'] ?? json['size'], fallback: 320),
      amenities: SafeParser.toList<String>(
        json['amenities'],
        (item) => SafeParser.toStr(item),
      ),
      isAvailable: SafeParser.toBool(json['is_available'] ?? json['isAvailable'], fallback: true),
      images: SafeParser.toImageList(
        json['images'] ?? json['image'],
        fallback: const ['https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800&q=80'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'name': name,
      'description': description,
      'price_per_night': pricePerNight,
      'capacity': capacity,
      'bed_type': bedType,
      'size_sq_ft': sizeSqFt,
      'amenities': amenities,
      'is_available': isAvailable,
      'images': images,
    };
  }

  factory RoomModel.fromEntity(Room entity) {
    return RoomModel(
      id: entity.id,
      hotelId: entity.hotelId,
      name: entity.name,
      description: entity.description,
      pricePerNight: entity.pricePerNight,
      capacity: entity.capacity,
      bedType: entity.bedType,
      sizeSqFt: entity.sizeSqFt,
      amenities: entity.amenities,
      isAvailable: entity.isAvailable,
      images: entity.images,
    );
  }
}
