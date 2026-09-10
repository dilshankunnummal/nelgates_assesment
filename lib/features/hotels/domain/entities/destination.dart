import 'package:equatable/equatable.dart';

class Destination extends Equatable {
  final String id;
  final String name; // e.g. "Goa"
  final String state; // e.g. "Goa"
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

  @override
  List<Object?> get props => [id, name, state, country, image, hotelCount, tagline];
}
