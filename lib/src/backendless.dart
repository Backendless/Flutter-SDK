part of backendless_sdk;

class Backendless {
  static final data = BackendlessData();

  static final BackendlessPrefs _prefs = BackendlessPrefs();

  static Future initApp(
      {String? applicationId,
      String? androidApiKey,
      String? iosApiKey,
      String? jsApiKey,
      String? customDomain}) async {
    if (customDomain != null && customDomain.isNotEmpty) {
      _prefs.initPreferences(customDomain: customDomain);
    } else if (applicationId != null && applicationId.isNotEmpty) {
      String? apiKey;

      if (kIsWeb) {
        apiKey = jsApiKey;
      } else if (io.Platform.isAndroid) {
        apiKey = androidApiKey;
      } else {
        apiKey = iosApiKey;
      }

      if (apiKey == null) throw Exception('ApiKey must not be null');

      await _prefs.initPreferences(appId: applicationId, apiKey: apiKey);
    }
  }

  static String get apiKey => _prefs.apiKey;

  static String get applicationId => _prefs.appId;

  static String get url => _prefs.url;
}
