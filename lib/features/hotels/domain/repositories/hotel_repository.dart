import '../../../../core/error/failures.dart';
import '../../domain/entities/destination.dart';
import '../../domain/entities/hotel.dart';

abstract class HotelRepository {
  Future<({Failure? failure, List<Hotel>? hotels})> getHotels({
    String? search,
    String? destination,
    double? minPrice,
    double? maxPrice,
    double? rating,
    String? sort,
  });

  Future<({Failure? failure, Hotel? hotel})> getHotelById(String id);

  Future<({Failure? failure, List<Destination>? destinations})> getDestinations();
}
