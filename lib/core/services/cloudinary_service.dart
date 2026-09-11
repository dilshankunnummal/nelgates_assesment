import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../config/app_environment.dart';
import '../error/exceptions.dart';
import '../utils/app_logger.dart';

class CloudinaryService {
  final Dio _dio;
  final ImagePicker _picker;

  CloudinaryService({Dio? dio, ImagePicker? picker})
      : _dio = dio ?? Dio(),
        _picker = picker ?? ImagePicker();

  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 82,
      );
      if (image != null) {
        AppLogger.cloudinary('Picked image: ${image.name} (${await image.length()} bytes)');
      }
      return image;
    } catch (e) {
      AppLogger.cloudinary('Failed to pick image', error: e);
      throw ServerException(message: 'Failed to pick image: $e');
    }
  }

  Future<String> uploadImage({
    required dynamic imageFile,
    String folder = 'users/profile',
    String? userId,
  }) async {
    try {
      AppLogger.cloudinary('Starting direct CDN image upload to folder: $folder...');
      Uint8List imageBytes;
      String filename = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      if (imageFile is XFile) {
        imageBytes = await imageFile.readAsBytes();
        filename = imageFile.name;
      } else if (imageFile is File) {
        imageBytes = await imageFile.readAsBytes();
      } else if (imageFile is Uint8List) {
        imageBytes = imageFile;
      } else {
        throw const ServerException(message: 'Unsupported image format');
      }

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(imageBytes, filename: filename),
        'upload_preset': AppEnvironment.cloudinaryUploadPreset,
        'folder': '$folder/${userId ?? "guest"}',
      });

      final response = await _dio.post(
        AppEnvironment.cloudinaryBaseUrl,
        data: formData,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final secureUrl = response.data['secure_url']?.toString();
        if (secureUrl != null && secureUrl.isNotEmpty) {
          AppLogger.cloudinary('Upload successful! Secure CDN URL: $secureUrl', isSuccess: true);
          return secureUrl;
        }
      }

      AppLogger.cloudinary('Cloudinary response status ${response.statusCode}: ${response.data}', error: response.statusMessage);

      return 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80';
    } catch (e) {
      AppLogger.cloudinary('Direct upload exception, using default avatar fallback', error: e);

      return 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80';
    }
  }
}
