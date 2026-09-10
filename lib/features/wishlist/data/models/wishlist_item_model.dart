import '../../../../core/utils/safe_parser.dart';
import '../../../../features/hotels/data/models/hotel_model.dart';
import '../../domain/entities/wishlist_item.dart';

class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({
    required super.hotelId,
    required super.hotel,
    required super.addedAt,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final hotelMap = SafeParser.toMap(json['hotel']);
    final hotel = HotelModel.fromJson(hotelMap);
    final hotelId = SafeParser.toStr(json['hotel_id'] ?? json['hotelId'], fallback: hotel.id);
    final addedAt = SafeParser.toDateTime(json['added_at'] ?? json['addedAt']) ?? DateTime.now();

    return WishlistItemModel(
      hotelId: hotelId,
      hotel: hotel,
      addedAt: addedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final hotelJson = hotel is HotelModel
        ? (hotel as HotelModel).toJson()
        : HotelModel.fromEntity(hotel).toJson();
    return {
      'hotel_id': hotelId,
      'hotel': hotelJson,
      'added_at': addedAt.toIso8601String(),
    };
  }

  factory WishlistItemModel.fromEntity(WishlistItem entity) {
    return WishlistItemModel(
      hotelId: entity.hotelId,
      hotel: entity.hotel,
      addedAt: entity.addedAt,
    );
  }
}
