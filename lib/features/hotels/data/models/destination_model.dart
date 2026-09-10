import '../../../../core/utils/safe_parser.dart';
import '../../domain/entities/destination.dart';

class DestinationModel extends Destination {
  const DestinationModel({
    required super.id,
    required super.name,
    required super.state,
    required super.country,
    required super.image,
    required super.hotelCount,
    required super.tagline,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: SafeParser.toStr(json['id'], fallback: 'DST-001'),
      name: SafeParser.toStr(json['name'], fallback: 'Goa'),
      state: SafeParser.toStr(json['state'], fallback: 'Goa'),
      country: SafeParser.toStr(json['country'], fallback: 'India'),
      image: SafeParser.toImageUrl(
        json['image'] ?? json['image_url'],
        fallback: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800&q=80',
      ),
      hotelCount: SafeParser.toInt(json['hotel_count'] ?? json['hotels_count'], fallback: 12),
      tagline: SafeParser.toStr(json['tagline'], fallback: 'Sun, sand, and serene beaches'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'country': country,
      'image': image,
      'hotel_count': hotelCount,
      'tagline': tagline,
    };
  }

  factory DestinationModel.fromEntity(Destination entity) {
    return DestinationModel(
      id: entity.id,
      name: entity.name,
      state: entity.state,
      country: entity.country,
      image: entity.image,
      hotelCount: entity.hotelCount,
      tagline: entity.tagline,
    );
  }
}
