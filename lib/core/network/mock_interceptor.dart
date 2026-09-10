import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import 'mock_hotel_data.dart';

class MockInterceptor extends Interceptor {
  // In-memory state for mock API bookings & wishlist during app execution
  static final List<Map<String, dynamic>> _bookings = [];
  static final List<String> _wishlistHotelIds = ['HTL-001', 'HTL-003'];

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Simulate realistic mobile network delay
    await Future.delayed(const Duration(milliseconds: 250));

    final path = options.path;
    final method = options.method.toUpperCase();

    // 1. POST /auth/login
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
              'user': {
                'id': 'USR-HR-001',
                'email': AppConstants.hrEmail,
                'name': AppConstants.hrName,
                'role': 'hr',
                'avatar': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&q=80',
                'phone': '+91 9811223344',
              },
              'token': 'mock_jwt_token_hr_secure',
              'expires_at': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
            },
          ),
        );
      } else if (email == AppConstants.employeeEmail.toLowerCase() && password == AppConstants.employeePassword) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'user': {
                'id': 'USR-EMP-002',
                'email': AppConstants.employeeEmail,
                'name': AppConstants.employeeName,
                'role': 'employee',
                'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80',
                'phone': '+91 9876543210',
              },
              'token': 'mock_jwt_token_employee_secure',
              'expires_at': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
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
              data: {'message': 'Invalid email or password. Please verify credentials.'},
            ),
            type: DioExceptionType.badResponse,
            message: 'Invalid credentials',
          ),
        );
      }
    }

    // 2. GET /destinations
    if (path.endsWith('/destinations') && method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'destinations': mockDestinationsData},
        ),
      );
    }

    // 3. GET /hotels/{id}
    final hotelDetailMatch = RegExp(r'/hotels/([^/?]+)$').firstMatch(path);
    if (hotelDetailMatch != null && method == 'GET' && !path.endsWith('/hotels')) {
      final id = hotelDetailMatch.group(1);
      final hotel = mockHotelsData.firstWhere(
        (h) => h['id'] == id,
        orElse: () => {},
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

    // 4. GET /hotels
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
        // Expand common Indian city aliases
        final searchAliases = <String>{search};
        if (search.contains('bangalore')) searchAliases.add('bengaluru');
        if (search.contains('bengaluru')) searchAliases.add('bangalore');
        if (search.contains('coorg')) searchAliases.add('madikeri');
        if (search.contains('madikeri')) searchAliases.add('coorg');
        if (search.contains('calicut')) searchAliases.add('kozhikode');
        if (search.contains('kozhikode')) searchAliases.add('calicut');
        if (search.contains('trivandrum')) searchAliases.add('thiruvananthapuram');
        if (search.contains('thiruvananthapuram')) searchAliases.add('trivandrum');
        if (search.contains('pondicherry')) searchAliases.add('puducherry');
        if (search.contains('puducherry')) searchAliases.add('pondicherry');
        if (search.contains('alleppey')) searchAliases.add('alappuzha');
        if (search.contains('alappuzha')) searchAliases.add('alleppey');

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
        final destQuery = destination.toLowerCase();
        final destAliases = <String>{destQuery};
        if (destQuery == 'bangalore') destAliases.add('bengaluru');
        if (destQuery == 'bengaluru') destAliases.add('bangalore');
        if (destQuery == 'coorg') destAliases.add('madikeri');
        if (destQuery == 'madikeri') destAliases.add('coorg');
        if (destQuery == 'calicut') destAliases.add('kozhikode');
        if (destQuery == 'kozhikode') destAliases.add('calicut');
        if (destQuery == 'trivandrum') destAliases.add('thiruvananthapuram');
        if (destQuery == 'thiruvananthapuram') destAliases.add('trivandrum');
        if (destQuery == 'pondicherry') destAliases.add('puducherry');
        if (destQuery == 'puducherry') destAliases.add('pondicherry');
        if (destQuery == 'alleppey') destAliases.add('alappuzha');
        if (destQuery == 'alappuzha') destAliases.add('alleppey');

        filtered = filtered.where((h) {
          final dest = h['destination'].toString().toLowerCase();
          final city = h['city'].toString().toLowerCase();
          final state = (h['state'] ?? '').toString().toLowerCase();

          return destAliases.contains(dest) ||
              destAliases.contains(city) ||
              destAliases.contains(state) ||
              destAliases.any((a) => dest.contains(a) || city.contains(a) || state.contains(a));
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

    // 5. GET /bookings
    if (path.endsWith('/bookings') && method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'bookings': _bookings},
        ),
      );
    }

    // 6. POST /bookings
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

    // 7. PATCH /bookings/{id}/cancel
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

    // 8. Wishlist
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
