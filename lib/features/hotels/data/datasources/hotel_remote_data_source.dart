import '../../../../core/network/api_client.dart';
import '../../../../core/utils/safe_parser.dart';
import '../models/destination_model.dart';
import '../models/hotel_model.dart';

abstract class HotelRemoteDataSource {
  Future<List<HotelModel>> getHotels({
    String? search,
    String? destination,
    double? minPrice,
    double? maxPrice,
    double? rating,
    String? sort,
  });

  Future<HotelModel> getHotelById(String id);

  Future<List<DestinationModel>> getDestinations();
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  final ApiClient apiClient;

  HotelRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<HotelModel>> getHotels({
    String? search,
    String? destination,
    double? minPrice,
    double? maxPrice,
    double? rating,
    String? sort,
  }) async {
    final query = <String, dynamic>{};
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (destination != null && destination.isNotEmpty) query['destination'] = destination;
    if (minPrice != null) query['min_price'] = minPrice;
    if (maxPrice != null) query['max_price'] = maxPrice;
    if (rating != null) query['rating'] = rating;
    if (sort != null) query['sort'] = sort;

    final response = await apiClient.get('/hotels', queryParameters: query);
    final data = SafeParser.toMap(response.data);
    final rawList = data['hotels'];
    return SafeParser.toList<HotelModel>(
      rawList,
      (item) => HotelModel.fromJson(SafeParser.toMap(item)),
    );
  }

  @override
  Future<HotelModel> getHotelById(String id) async {
    final response = await apiClient.get('/hotels/$id');
    final data = SafeParser.toMap(response.data);
    final hotelMap = SafeParser.toMap(data['hotel']);
    return HotelModel.fromJson(hotelMap);
  }

  @override
  Future<List<DestinationModel>> getDestinations() async {
    final response = await apiClient.get('/destinations');
    final data = SafeParser.toMap(response.data);
    final rawList = data['destinations'];
    return SafeParser.toList<DestinationModel>(
      rawList,
      (item) => DestinationModel.fromJson(SafeParser.toMap(item)),
    );
  }
}
