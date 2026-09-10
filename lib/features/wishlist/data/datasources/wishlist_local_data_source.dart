import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../features/hotels/data/models/hotel_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<HotelModel>> getWishlist();
  Future<void> addToWishlist(HotelModel hotel);
  Future<void> removeFromWishlist(String hotelId);
  Future<bool> isWishlisted(String hotelId);
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final Box box;

  WishlistLocalDataSourceImpl({required this.box});

  @override
  Future<List<HotelModel>> getWishlist() async {
    try {
      final values = box.values;
      final list = <HotelModel>[];
      for (final val in values) {
        if (val is Map) {
          list.add(HotelModel.fromJson(Map<String, dynamic>.from(val)));
        }
      }
      return list;
    } catch (e) {
      throw CacheException(message: 'Failed to load wishlist from local storage: $e');
    }
  }

  @override
  Future<void> addToWishlist(HotelModel hotel) async {
    try {
      await box.put(hotel.id, hotel.toJson());
    } catch (e) {
      throw CacheException(message: 'Failed to save hotel to wishlist: $e');
    }
  }

  @override
  Future<void> removeFromWishlist(String hotelId) async {
    try {
      await box.delete(hotelId);
    } catch (e) {
      throw CacheException(message: 'Failed to remove hotel from wishlist: $e');
    }
  }

  @override
  Future<bool> isWishlisted(String hotelId) async {
    try {
      return box.containsKey(hotelId);
    } catch (e) {
      throw CacheException(message: 'Failed to check wishlist status: $e');
    }
  }
}
