import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/core/network/api_client.dart';
import 'package:nelegate_assessment/features/hotels/data/datasources/hotel_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late HotelRemoteDataSourceImpl remoteDataSource;

  final tHotelsResponse = {
    'hotels': [
      {
        'id': 'HTL-KER-001',
        'name': 'Grand Hyatt Kochi Bolgatty',
        'destination': 'Kochi',
        'city': 'Kochi',
        'state': 'Kerala',
        'star_rating': 5,
        'address': 'Bolgatty Island, Kochi',
        'rating': 4.8,
        'review_count': 842,
        'price_per_night': 9499.0,
        'images': ['https://hotel.com/1.jpg'],
        'description': 'Waterfront luxury stay',
        'amenities': [],
        'rooms': [],
        'cancellation_policy': 'Free cancellation',
        'latitude': 9.98,
        'longitude': 76.26,
      }
    ]
  };

  setUp(() {
    mockApiClient = MockApiClient();
    remoteDataSource = HotelRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  group('HotelRemoteDataSource', () {
    test('getHotels calls ApiClient get and parses list', () async {
      when(() => mockApiClient.get('/hotels', queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/hotels'),
                data: tHotelsResponse,
                statusCode: 200,
              ));

      final result = await remoteDataSource.getHotels(search: 'Kochi');

      expect(result.length, 1);
      expect(result.first.id, 'HTL-KER-001');
      verify(() => mockApiClient.get(
            '/hotels',
            queryParameters: {'search': 'Kochi'},
          )).called(1);
    });

    test('getHotelById calls ApiClient get and parses single hotel', () async {
      when(() => mockApiClient.get('/hotels/HTL-KER-001')).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/hotels/HTL-KER-001'),
            data: {'hotel': tHotelsResponse['hotels']!.first},
            statusCode: 200,
          ));

      final result = await remoteDataSource.getHotelById('HTL-KER-001');

      expect(result.id, 'HTL-KER-001');
      expect(result.name, 'Grand Hyatt Kochi Bolgatty');
    });
  });
}
