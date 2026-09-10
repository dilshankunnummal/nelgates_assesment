import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import 'mock_interceptor.dart';

abstract class ApiClient {
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  void setAuthToken(String? token);
}

class DioApiClient implements ApiClient {
  final Dio _dio;
  String? _authToken;

  DioApiClient({Dio? dio, bool useMock = true})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.booking.com/v1',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                sendTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    if (useMock) {
      _dio.interceptors.add(MockInterceptor());
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
      ),
    );
  }

  @override
  void setAuthToken(String? token) {
    _authToken = token;
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(message: 'Connection timed out. Please check your internet connection.');
      case DioExceptionType.connectionError:
        return const NetworkException(message: 'Unable to connect to server. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final data = e.response?.data;
        String message = 'Server returned an error';
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
        if (status == 401 || status == 403) {
          return AuthenticationException(message: message);
        }
        if (status == 422 || status == 400) {
          return ValidationException(message: message);
        }
        return ServerException(message: message, statusCode: status);
      case DioExceptionType.cancel:
        return const NetworkException(message: 'Request was cancelled.');
      default:
        return ServerException(message: e.message ?? 'An unexpected network error occurred.');
    }
  }
}
