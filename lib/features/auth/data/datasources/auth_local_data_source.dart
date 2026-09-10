import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auth_session_model.dart';

abstract class AuthLocalDataSource {
  Future<AuthSessionModel?> getSession();
  Future<void> saveSession(AuthSessionModel session);
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box box;

  AuthLocalDataSourceImpl({required this.box});

  @override
  Future<AuthSessionModel?> getSession() async {
    try {
      final raw = box.get(StorageConstants.authSessionKey);
      if (raw == null) return null;
      final Map<String, dynamic> map = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : Map<String, dynamic>.from(raw as Map);
      return AuthSessionModel.fromJson(map);
    } catch (e) {
      throw CacheException(message: 'Failed to read auth session from cache: $e');
    }
  }

  @override
  Future<void> saveSession(AuthSessionModel session) async {
    try {
      await box.put(StorageConstants.authSessionKey, session.toJson());
    } catch (e) {
      throw CacheException(message: 'Failed to save auth session to cache: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await box.delete(StorageConstants.authSessionKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear auth session: $e');
    }
  }
}
