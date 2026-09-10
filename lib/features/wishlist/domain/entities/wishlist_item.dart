import 'package:equatable/equatable.dart';
import '../../../../features/hotels/domain/entities/hotel.dart';

class WishlistItem extends Equatable {
  final String hotelId;
  final Hotel hotel;
  final DateTime addedAt;

  const WishlistItem({
    required this.hotelId,
    required this.hotel,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [hotelId, hotel, addedAt];
}
