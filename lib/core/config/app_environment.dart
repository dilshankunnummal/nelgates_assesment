enum AppDataSourceMode {
  mock,
  firebase,
}

class AppEnvironment {

  static AppDataSourceMode dataSourceMode = AppDataSourceMode.firebase;

  static bool get isFirebase => dataSourceMode == AppDataSourceMode.firebase;
  static bool get isMock => dataSourceMode == AppDataSourceMode.mock;

  static const String cloudinaryCloudName = 'dls5vxo49';
  static const String cloudinaryUploadPreset = 'hotel_booking_app';
  static const String cloudinaryBaseUrl = 'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload';

  static const String functionsRegion = 'us-central1';
}
