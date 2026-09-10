import '../../../../core/error/failures.dart';
import '../entities/destination.dart';
import '../entities/hotel.dart';
import '../repositories/hotel_repository.dart';

class GetHotelsUseCase {
  final HotelRepository _repository;
  const GetHotelsUseCase(this._repository);

  Future<({Failure? failure, List<Hotel>? hotels})> call({
    String? search,
    String? destination,
    double? minPrice,
    double? maxPrice,
    double? rating,
    String? sort,
  }) {
    return _repository.getHotels(
      search: search,
      destination: destination,
      minPrice: minPrice,
      maxPrice: maxPrice,
      rating: rating,
      sort: sort,
    );
  }
}

class GetHotelByIdUseCase {
  final HotelRepository _repository;
  const GetHotelByIdUseCase(this._repository);

  Future<({Failure? failure, Hotel? hotel})> call(String id) {
    return _repository.getHotelById(id);
  }
}

class GetDestinationsUseCase {
  final HotelRepository _repository;
  const GetDestinationsUseCase(this._repository);

  Future<({Failure? failure, List<Destination>? destinations})> call() {
    return _repository.getDestinations();
  }
}
