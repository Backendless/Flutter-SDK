part of backendless_sdk;

class Backendless {
  static final data = Data();
  static final customService = CustomService();
  static final cache = Cache();
  static final userService = UserService();
  static final files = FileService();
  static final messaging = Messaging();
  static final rt = RTConnector();

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
      //String? jsApiKey,
      String? customDomain}) async {
    if (customDomain != null && customDomain.isNotEmpty) {
      _prefs.initPreferences(customDomain: customDomain);

      _channelNative.setMethodCallHandler(
          (call) => _NativeFunctionsContainer.backendlessEventHandler(call));
      return;
    } else if (applicationId?.isNotEmpty ?? true) {
      String? apiKey;

      if (kIsWeb) {
        throw PlatformException(
            code: '0',
            message: 'In alpha version web unsupported for this skd.');
        //apiKey = jsApiKey;
      } else if (io.Platform.isAndroid) {
        apiKey = androidApiKey;
      } else {
        _channelNative.setMethodCallHandler(
            (call) => _NativeFunctionsContainer.backendlessEventHandler(call));
        apiKey = iosApiKey;
      }

      if (apiKey == null) {
        throw ArgumentError.value(ExceptionMessage.emptyNullApiKey);
      }

      await _prefs.initPreferences(appId: applicationId, apiKey: apiKey);
      _isInitialized = true;
      return;
    }

    throw ArgumentError.value(ExceptionMessage.emptyNullAppId);
  }

  static bool get isInitialized => _isInitialized;

  static String? get apiKey => _prefs.apiKey;

  static String? get applicationId => _prefs.appId;

  static String? get customDomain => _prefs.customDomain;

  static Future<NotificationAppLaunchDetails?> get appLaunchDetails =>
      flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  static String get url => _prefs.url;

  static set url(String url) {
    _prefs.url = url;
  }

  static Map<String, String>? get headers => _prefs.headers;

  static Future<void> setHeader(String value,
      {String? key, HeadersEnum? enumKey}) async {
    if (key == null && enumKey == null) {
      throw ArgumentError(
          '\'key\' or \'enumKey\' were null. At least one of them must be defined');
    }
    String keyHeader = key ?? enumKey!.header;

    if (keyHeader == 'user-token') {
      await Backendless.userService.setUserToken(value);
    }

    _prefs.headers[keyHeader] = value;
  }

  static Future<void> removeHeader({String? key, HeadersEnum? enumKey}) async {
    if (key == null && enumKey == null) {
      throw ArgumentError(
          '\'key\' or \'enumKey\' were null. At least one of them must be defined');
    }

    String keyToRemove = key ?? enumKey!.header;

    if (keyToRemove == 'user-token') {
      await Backendless.userService.removeUserToken();
    }

    _prefs.headers.remove(keyToRemove);
  }
}
