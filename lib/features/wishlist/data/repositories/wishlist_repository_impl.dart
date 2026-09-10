import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../features/hotels/data/models/hotel_model.dart';
import '../../../../features/hotels/domain/entities/hotel.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_local_data_source.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl({required this.localDataSource});

  @override
  Future<({Failure? failure, List<Hotel>? hotels})> getWishlist() async {
    try {
      final list = await localDataSource.getWishlist();
      return (failure: null, hotels: list);
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), hotels: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), hotels: null);
    }
  }

  @override
  Future<({Failure? failure, bool isWishlisted})> toggleWishlist(Hotel hotel) async {
    try {
      final exists = await localDataSource.isWishlisted(hotel.id);
      if (exists) {
        await localDataSource.removeFromWishlist(hotel.id);
        return (failure: null, isWishlisted: false);
      } else {
        final hotelModel = hotel is HotelModel ? hotel : HotelModel.fromEntity(hotel);
        await localDataSource.addToWishlist(hotelModel);
        return (failure: null, isWishlisted: true);
      }
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), isWishlisted: false);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), isWishlisted: false);
    }
  }

  @override
  Future<({Failure? failure, bool isWishlisted})> isHotelWishlisted(String hotelId) async {
    try {
      final exists = await localDataSource.isWishlisted(hotelId);
      return (failure: null, isWishlisted: exists);
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), isWishlisted: false);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), isWishlisted: false);
    }
  }
}
