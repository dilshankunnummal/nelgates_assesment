import '../../../../core/error/failures.dart';
import '../../../../features/hotels/domain/entities/hotel.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlistUseCase {
  final WishlistRepository repository;
  const GetWishlistUseCase(this.repository);

  Future<({Failure? failure, List<Hotel>? hotels})> call() {
    return repository.getWishlist();
  }
}

class ToggleWishlistUseCase {
  final WishlistRepository repository;
  const ToggleWishlistUseCase(this.repository);

  Future<({Failure? failure, bool isWishlisted})> call(Hotel hotel) {
    return repository.toggleWishlist(hotel);
  }
}

class IsHotelWishlistedUseCase {
  final WishlistRepository repository;
  const IsHotelWishlistedUseCase(this.repository);

  Future<({Failure? failure, bool isWishlisted})> call(String hotelId) {
    return repository.isHotelWishlisted(hotelId);
  }
}
