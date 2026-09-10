import '../../../../core/utils/safe_parser.dart';
import '../../domain/entities/amenity.dart';

class AmenityModel extends Amenity {
  const AmenityModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory AmenityModel.fromJson(dynamic json) {
    if (json is String) {
      return AmenityModel(
        id: json.toLowerCase().replaceAll(' ', '_'),
        name: json,
        icon: _iconForName(json),
      );
    }
    final map = SafeParser.toMap(json);
    final name = SafeParser.toStr(map['name'] ?? map['title'], fallback: 'Amenity');
    return AmenityModel(
      id: SafeParser.toStr(map['id'], fallback: name.toLowerCase().replaceAll(' ', '_')),
      name: name,
      icon: SafeParser.toStr(map['icon'], fallback: _iconForName(name)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  factory AmenityModel.fromEntity(Amenity entity) {
    return AmenityModel(
      id: entity.id,
      name: entity.name,
      icon: entity.icon,
    );
  }

  static String _iconForName(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wifi')) return 'wifi';
    if (lower.contains('pool')) return 'pool';
    if (lower.contains('spa')) return 'spa';
    if (lower.contains('gym') || lower.contains('fitness')) return 'fitness';
    if (lower.contains('breakfast') || lower.contains('dining') || lower.contains('restaurant')) {
      return 'restaurant';
    }
    if (lower.contains('bar')) return 'bar';
    if (lower.contains('parking')) return 'parking';
    if (lower.contains('ac') || lower.contains('air')) return 'ac';
    return 'check';
  }
}
