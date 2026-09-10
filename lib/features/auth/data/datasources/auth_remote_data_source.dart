import '../../../../core/network/api_client.dart';
import '../../../../core/utils/safe_parser.dart';
import '../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = SafeParser.toMap(response.data);
    final session = AuthSessionModel.fromJson(data);
    apiClient.setAuthToken(session.token);
    return session;
  }
}
