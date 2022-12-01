part of backendless_sdk;

class Backendless {
  static final data = Data();
  static final customService = CustomService();
  static final cache = Cache();
  static final userService = UserService();
  static final files = FileService();
  static final messaging = Messaging();

  static final BackendlessPrefs _prefs = BackendlessPrefs();
  static const MethodChannel _channelNative =
      MethodChannel('backendless/native_api');

  static bool _isInitialized = false;

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
        _channelNative.setMethodCallHandler(
            (call) => _NativeFunctionsContainer.backendlessEventHandler(call));
        apiKey = iosApiKey;
      }

      if (apiKey == null) {
        throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_API_KEY);
      }

      await _prefs.initPreferences(appId: applicationId, apiKey: apiKey);
      _isInitialized = true;
    }

    throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_APP_ID);
  }

  static bool get isInitialized => _isInitialized;

  static String? get apiKey => _prefs.apiKey;

  static String? get applicationId => _prefs.appId;

  static String? get customDomain => _prefs.customDomain;

  static String get url => _prefs.url;

  static set url(String url) {
    _prefs.url = url;
  }
}
