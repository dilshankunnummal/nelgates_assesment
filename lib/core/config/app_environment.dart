enum AppDataSourceMode {
  mock,
  firebase,
}

class AppEnvironment {
  /// Current data source mode. Set to [AppDataSourceMode.firebase] for production Firebase backend.
  static AppDataSourceMode dataSourceMode = AppDataSourceMode.firebase;

  static bool get isFirebase => dataSourceMode == AppDataSourceMode.firebase;
  static bool get isMock => dataSourceMode == AppDataSourceMode.mock;

  // Cloudinary Configuration
  static const String cloudinaryCloudName = 'dls5vxo49';
  static const String cloudinaryUploadPreset = 'hotel_booking_app';
  static const String cloudinaryBaseUrl = 'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload';

  // Cloud Functions Endpoint (if calling direct HTTP or via Firebase Functions SDK)
  static const String functionsRegion = 'us-central1';
}
