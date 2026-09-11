import 'package:equatable/equatable.dart';

class Destination extends Equatable {
  final String id;
  final String name;
  final String state;
  final String country;
  final String image;
  final int hotelCount;
  final String tagline;

  const Destination({
    required this.id,
    required this.name,
    required this.state,
    required this.country,
    required this.image,
    required this.hotelCount,
    required this.tagline,
  });

  Destination copyWith({
    String? id,
    String? name,
    String? state,
    String? country,
    String? image,
    int? hotelCount,
    String? tagline,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      country: country ?? this.country,
      image: image ?? this.image,
      hotelCount: hotelCount ?? this.hotelCount,
      tagline: tagline ?? this.tagline,
    );
  }

  @override
  List<Object?> get props => [id, name, state, country, image, hotelCount, tagline];
}
