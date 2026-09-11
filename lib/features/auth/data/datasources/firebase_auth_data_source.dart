import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/safe_parser.dart';
import '../models/auth_session_model.dart';
import '../models/user_model.dart';

abstract class FirebaseAuthDataSource {
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  });

  Future<AuthSessionModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? profileImageUrl,
    String role = 'employee',
  });

  Future<void> forgotPassword({required String email});

  Future<AuthSessionModel?> getCurrentSession();

  Future<void> logout();

  Stream<fb_auth.User?> get authStateChanges;
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  fb_auth.FirebaseAuth? _firebaseAuth;
  FirebaseFirestore? _firestore;

  FirebaseAuthDataSourceImpl({
    this._firebaseAuth,
    this._firestore,
  });

  fb_auth.FirebaseAuth get _auth => _firebaseAuth ??= fb_auth.FirebaseAuth.instance;
  FirebaseFirestore get _db => _firestore ??= FirebaseFirestore.instance;

  @override
  Stream<fb_auth.User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (e) {
      AppLogger.auth('Error observing authStateChanges', error: e);
      return const Stream.empty();
    }
  }

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.auth('Attempting sign in for: $email...');
      fb_auth.UserCredential credential;

      try {
        credential = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      } on fb_auth.FirebaseAuthException catch (signInErr) {

        final cleanEmail = email.trim().toLowerCase();
        final isEmployeeDemo = cleanEmail == 'employee@hotel.com';
        final isHrDemo = cleanEmail == 'hr@hotel.com';

        if ((isEmployeeDemo || isHrDemo) &&
            (signInErr.code == 'user-not-found' || signInErr.code == 'invalid-credential')) {
          AppLogger.auth('Auto-provisioning demo account in Firebase for $cleanEmail...');
          credential = await _auth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
          final role = isHrDemo ? 'hr' : 'employee';
          final name = isHrDemo ? 'Sarah Jenkins (HR Manager)' : 'Alex Mercer (Travel Associate)';
          const defaultAvatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80';
          await credential.user?.updateDisplayName(name);
          await _db.collection('users').doc(credential.user!.uid).set({
            'id': credential.user!.uid,
            'name': name,
            'email': email.trim(),
            'role': role,
            'isActive': true,
            'profileImageUrl': defaultAvatar,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } else {
          rethrow;
        }
      }

      final fbUser = credential.user;
      if (fbUser == null) {
        throw const AuthenticationException(message: 'Login failed: User not found.');
      }

      AppLogger.auth('FirebaseAuth successful for UID: ${fbUser.uid}. Fetching Firestore profile...');

      UserModel userModel;
      const defaultAvatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80';
      try {
        final doc = await _db.collection('users').doc(fbUser.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          userModel = UserModel(
            id: fbUser.uid,
            email: fbUser.email ?? email,
            name: SafeParser.toStr(data['name'], fallback: fbUser.displayName ?? 'Guest User'),
            role: SafeParser.toStr(data['role'], fallback: 'employee'),
            avatar: SafeParser.toImageUrl(
              data['profileImageUrl'] ?? data['avatar'] ?? fbUser.photoURL,
              fallback: defaultAvatar,
            ),
            phone: data['phone']?.toString() ?? fbUser.phoneNumber,
          );
        } else {

          userModel = UserModel(
            id: fbUser.uid,
            email: fbUser.email ?? email,
            name: fbUser.displayName ?? 'Guest User',
            role: 'employee',
            avatar: fbUser.photoURL ?? defaultAvatar,
            phone: fbUser.phoneNumber,
          );
        }
      } catch (docErr) {
        AppLogger.auth('Notice: User Firestore document fetch fallback: $docErr');
        userModel = UserModel(
          id: fbUser.uid,
          email: fbUser.email ?? email,
          name: fbUser.displayName ?? 'Guest User',
          role: 'employee',
          avatar: fbUser.photoURL ?? defaultAvatar,
          phone: fbUser.phoneNumber,
        );
      }

      final token = await fbUser.getIdToken() ?? 'firebase_token_${fbUser.uid}';
      AppLogger.auth('Login complete for ${userModel.email} [${userModel.role}]', isSuccess: true);
      return AuthSessionModel(
        user: userModel,
        token: token,
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      AppLogger.auth('FirebaseAuthException [${e.code}]: ${e.message}', error: e);
      throw AuthenticationException(message: _mapFirebaseAuthError(e));
    } catch (e) {
      AppLogger.auth('Unexpected sign in error', error: e);
      throw AuthenticationException(message: 'Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthSessionModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? profileImageUrl,
    String role = 'employee',
  }) async {
    try {
      AppLogger.auth('Registering user: $email with role: $role...');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final fbUser = credential.user;
      if (fbUser == null) {
        throw const AuthenticationException(message: 'Registration failed: Unable to create account.');
      }

      await fbUser.updateDisplayName(name);
      if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
        await fbUser.updatePhotoURL(profileImageUrl);
      }

      final userDoc = {
        'id': fbUser.uid,
        'name': name,
        'email': email.trim(),
        'phone': phone,
        'profileImageUrl': profileImageUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80',
        'role': role,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _db.collection('users').doc(fbUser.uid).set(userDoc, SetOptions(merge: true));
      AppLogger.auth('Firestore user document created for UID: ${fbUser.uid}', isSuccess: true);

      final userModel = UserModel(
        id: fbUser.uid,
        email: email,
        name: name,
        role: role,
        avatar: profileImageUrl,
        phone: phone,
      );

      final token = await fbUser.getIdToken() ?? 'firebase_token_${fbUser.uid}';
      return AuthSessionModel(
        user: userModel,
        token: token,
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      AppLogger.auth('FirebaseAuthException during registration [${e.code}]: ${e.message}', error: e);
      throw AuthenticationException(message: _mapFirebaseAuthError(e));
    } catch (e) {
      AppLogger.auth('Unexpected registration error', error: e);
      throw AuthenticationException(message: 'Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      AppLogger.auth('Sending password reset email to: $email...');
      await _auth.sendPasswordResetEmail(email: email.trim());
      AppLogger.auth('Password reset email sent successfully.', isSuccess: true);
    } on fb_auth.FirebaseAuthException catch (e) {
      AppLogger.auth('Password reset error [${e.code}]', error: e);
      throw AuthenticationException(message: _mapFirebaseAuthError(e));
    } catch (e) {
      AppLogger.auth('Password reset error', error: e);
      throw AuthenticationException(message: 'Password reset request failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthSessionModel?> getCurrentSession() async {
    try {
      final fbUser = _auth.currentUser;
      if (fbUser == null) return null;

      final doc = await _db.collection('users').doc(fbUser.uid).get();

      UserModel userModel;
      const defaultAvatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80';
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        userModel = UserModel(
          id: fbUser.uid,
          email: fbUser.email ?? '',
          name: SafeParser.toStr(data['name'], fallback: fbUser.displayName ?? 'Guest User'),
          role: SafeParser.toStr(data['role'], fallback: 'employee'),
          avatar: SafeParser.toImageUrl(
            data['profileImageUrl'] ?? data['avatar'] ?? fbUser.photoURL,
            fallback: defaultAvatar,
          ),
          phone: data['phone']?.toString() ?? fbUser.phoneNumber,
        );
      } else {
        userModel = UserModel(
          id: fbUser.uid,
          email: fbUser.email ?? '',
          name: fbUser.displayName ?? 'Guest User',
          role: 'employee',
          avatar: fbUser.photoURL ?? defaultAvatar,
          phone: fbUser.phoneNumber,
        );
      }

      final token = await fbUser.getIdToken() ?? 'firebase_token_${fbUser.uid}';
      return AuthSessionModel(
        user: userModel,
        token: token,
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (_) {}
  }

  String _mapFirebaseAuthError(fb_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled in your Firebase Console. Go to Firebase Console > Authentication > Sign-in method and enable "Email/Password".';
      case 'user-not-found':
      case 'invalid-credential':
        return 'Invalid email or password. If you haven\'t created this account yet, please tap "Sign Up" below.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email address is already registered. Please sign in instead.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'network-request-failed':
        return 'Network connection issue. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a few minutes before trying again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      default:
        return e.message ?? 'Authentication error [${e.code}]. Please try again.';
    }
  }
}
