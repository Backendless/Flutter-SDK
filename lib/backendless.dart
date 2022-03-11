part of backendless_sdk;

class Backendless {
  static final data = Data();
  static final customService = CustomService();
  static final cache = Cache();
  static final userService = UserService();
  static final files = FileService();
  static final messaging = Messaging();

  static final BackendlessPrefs _prefs = BackendlessPrefs();

  ///This method must be called once before sending the request to the `Backendless` server.
  ///Must be an app ID and API key or custom domain.
  static Future initApp(
      {String? applicationId,
      String? androidApiKey,
      String? iosApiKey,
      String? jsApiKey,
      String? customDomain}) async {
    if (customDomain != null && customDomain.isNotEmpty) {
      _prefs.initPreferences(customDomain: customDomain);
    } else if (applicationId?.isNotEmpty ?? true) {
      String? apiKey;

      if (kIsWeb) {
        apiKey = jsApiKey;
      } else if (io.Platform.isAndroid) {
        apiKey = androidApiKey;
      } else {
        apiKey = iosApiKey;
      }

      if (apiKey == null)
        throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_API_KEY);

      await _prefs.initPreferences(appId: applicationId, apiKey: apiKey);
      return;
    }

    throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_APP_ID);
  }

  static String get apiKey => _prefs.apiKey;

  static String get applicationId => _prefs.appId;

  static String get url => _prefs.url;
}
