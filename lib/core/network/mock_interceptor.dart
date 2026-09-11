import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../utils/destination_utils.dart';
import 'mock_hotel_data.dart';

class MockInterceptor extends Interceptor {

  static final List<Map<String, dynamic>> _bookings = [];
  static final List<String> _wishlistHotelIds = ['HTL-001', 'HTL-003'];

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    await Future.delayed(const Duration(milliseconds: 250));

    final path = options.path;
    final method = options.method.toUpperCase();

    if (path.endsWith('/auth/login') && method == 'POST') {
      final data = options.data is Map ? options.data as Map : jsonDecode(options.data.toString()) as Map;
      final email = (data['email'] ?? '').toString().trim().toLowerCase();
      final password = (data['password'] ?? '').toString().trim();

      if (email == AppConstants.hrEmail.toLowerCase() && password == AppConstants.hrPassword) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'token': 'mock_jwt_token_nelegate_assessment_auth_success',
              'user': {
                'id': 'USR-HR-001',
                'name': AppConstants.hrName,
                'email': AppConstants.hrEmail,
                'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
                'phone': '+91 98765 43210',
              }
            },
          ),
        );
      } else if (email == AppConstants.employeeEmail.toLowerCase() && password == AppConstants.employeePassword) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'token': 'mock_jwt_token_employee_secure',
              'user': {
                'id': 'USR-EMP-002',
                'name': AppConstants.employeeName,
                'email': AppConstants.employeeEmail,
                'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
                'phone': '+91 98765 43210',
              }
            },
          ),
        );
      } else {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {'message': 'Invalid email or password. Please check your credentials.'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }
    }

    if (path.endsWith('/destinations') && method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'destinations': mockDestinationsData},
        ),
      );
    }

    final hotelIdMatch = RegExp(r'/hotels/([^/?]+)$').firstMatch(path);
    if (hotelIdMatch != null && method == 'GET') {
      final id = hotelIdMatch.group(1);
      final hotel = mockHotelsData.firstWhere(
        (h) => h['id'] == id,
        orElse: () => <String, dynamic>{},
      );

      if (hotel.isNotEmpty) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {'hotel': hotel},
          ),
        );
      } else {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 404,
              data: {'message': 'Hotel not found with ID $id'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }
    }

    if (path.endsWith('/hotels') && method == 'GET') {
      var filtered = List<Map<String, dynamic>>.from(mockHotelsData);
      final queryParams = options.queryParameters;

      final search = queryParams['search']?.toString().toLowerCase().trim();
      final destination = queryParams['destination']?.toString().toLowerCase().trim();
      final minPrice = queryParams['min_price'] != null ? double.tryParse(queryParams['min_price'].toString()) : null;
      final maxPrice = queryParams['max_price'] != null ? double.tryParse(queryParams['max_price'].toString()) : null;
      final minRating = queryParams['rating'] != null ? double.tryParse(queryParams['rating'].toString()) : null;
      final sort = queryParams['sort']?.toString();

      if (search != null && search.isNotEmpty) {
        final searchAliases = DestinationUtils.getAliases(search);

        filtered = filtered.where((h) {
          final name = h['name'].toString().toLowerCase();
          final dest = h['destination'].toString().toLowerCase();
          final city = h['city'].toString().toLowerCase();
          final state = (h['state'] ?? '').toString().toLowerCase();
          final desc = (h['description'] ?? '').toString().toLowerCase();

          return searchAliases.any((q) =>
              name.contains(q) ||
              dest.contains(q) ||
              city.contains(q) ||
              state.contains(q) ||
              desc.contains(q));
        }).toList();
      }

      if (destination != null && destination.isNotEmpty && destination != 'all') {
        filtered = filtered.where((h) {
          final dest = h['destination'].toString();
          final city = h['city'].toString();
          final state = (h['state'] ?? '').toString();

          return DestinationUtils.matchesDestination(
            hotelDestination: dest,
            hotelCity: city,
            hotelState: state,
            targetDestination: destination,
          );
        }).toList();
      }

      if (minPrice != null) {
        filtered = filtered.where((h) => (h['price_per_night'] as num) >= minPrice).toList();
      }

      if (maxPrice != null) {
        filtered = filtered.where((h) => (h['price_per_night'] as num) <= maxPrice).toList();
      }

      if (minRating != null) {
        filtered = filtered.where((h) => (h['rating'] as num) >= minRating).toList();
      }

      if (sort != null) {
        if (sort == 'price_low_high') {
          filtered.sort((a, b) => (a['price_per_night'] as num).compareTo(b['price_per_night'] as num));
        } else if (sort == 'price_high_low') {
          filtered.sort((a, b) => (b['price_per_night'] as num).compareTo(a['price_per_night'] as num));
        } else if (sort == 'rating') {
          filtered.sort((a, b) => (b['rating'] as num).compareTo(a['rating'] as num));
        }
      }

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'hotels': filtered},
        ),
      );
    }

    if (path.endsWith('/bookings') && method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'bookings': _bookings},
        ),
      );
    }

    if (path.endsWith('/bookings') && method == 'POST') {
      final data = options.data is Map ? Map<String, dynamic>.from(options.data as Map) : jsonDecode(options.data.toString()) as Map<String, dynamic>;
      _bookings.insert(0, data);
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {'booking': data},
        ),
      );
    }

    final cancelMatch = RegExp(r'/bookings/([^/?]+)/cancel$').firstMatch(path);
    if (cancelMatch != null && method == 'PATCH') {
      final id = cancelMatch.group(1);
      final index = _bookings.indexWhere((b) => b['id'] == id);
      if (index != -1) {
        _bookings[index]['status'] = 'cancelled';
        _bookings[index]['cancellation_reason'] = 'Customer requested cancellation';
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {'booking': _bookings[index]},
          ),
        );
      }
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'id': id, 'status': 'cancelled'},
        ),
      );
    }

    if (path.endsWith('/wishlist') && method == 'GET') {
      final wishlistHotels = mockHotelsData.where((h) => _wishlistHotelIds.contains(h['id'])).toList();
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'wishlist': wishlistHotels},
        ),
      );
    }

    if (path.endsWith('/wishlist') && method == 'POST') {
      final data = options.data is Map ? options.data as Map : jsonDecode(options.data.toString()) as Map;
      final hotelId = data['hotel_id']?.toString() ?? '';
      if (hotelId.isNotEmpty && !_wishlistHotelIds.contains(hotelId)) {
        _wishlistHotelIds.add(hotelId);
      }
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {'success': true, 'hotel_id': hotelId},
        ),
      );
    }

    final deleteWishlistMatch = RegExp(r'/wishlist/([^/?]+)$').firstMatch(path);
    if (deleteWishlistMatch != null && method == 'DELETE') {
      final hotelId = deleteWishlistMatch.group(1);
      _wishlistHotelIds.remove(hotelId);
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'success': true, 'hotel_id': hotelId},
        ),
      );
    }

    super.onRequest(options, handler);
  }
}
