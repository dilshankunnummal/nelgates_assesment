import '../../../../core/error/failures.dart';
import '../../../../features/hotels/domain/entities/hotel.dart';

abstract class WishlistRepository {
  Future<({Failure? failure, List<Hotel>? hotels})> getWishlist();
  Future<({Failure? failure, bool isWishlisted})> toggleWishlist(Hotel hotel);
  Future<({Failure? failure, bool isWishlisted})> isHotelWishlisted(String hotelId);
}
