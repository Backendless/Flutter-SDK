part of backendless_sdk;

class Backendless {
  static final data = new BackendlessData();
  static final cache = new BackendlessCache();
  static final commerce = new BackendlessCommerce();
  static final counters = new BackendlessCounters();
  static final customService = new BackendlessCustomService();
  static final events = new BackendlessEvents();
  static final files = new BackendlessFiles();
  static final logging = new BackendlessLogging();
  static final messaging = new BackendlessMessaging();
  static final rt = new BackendlessRT();
  static final userService = new BackendlessUserService();

  static final BackendlessPrefs _prefs = new BackendlessPrefs();

  static const MethodChannel _channel = const MethodChannel('backendless');

  static Future<void> initApp(
      {String? applicationId,
      String? androidApiKey,
      String? iosApiKey,
      String? jsApiKey,
      String? customDomain}) async {
    if (customDomain != null) {
      _prefs.initPreferences(customDomain: customDomain);
      return _channel
          .invokeMethod('Backendless.initApp', {'customDomain': customDomain});
    }

    String apiKey;
    if (kIsWeb)
      apiKey = jsApiKey!;
    else if (Platform.isAndroid)
      apiKey = androidApiKey!;
    else if (Platform.isIOS)
      apiKey = iosApiKey!;
    else
      return;

    _prefs.initPreferences(appId: applicationId, apiKey: apiKey);

    return _channel.invokeMethod('Backendless.initApp',
        <String, dynamic>{'applicationId': applicationId, 'apiKey': apiKey});
  }

  static get apiKey => _prefs.apiKey;

  static get applicationId => _prefs.appId;

  static get url => _prefs.url;

  static Future<bool?> isInitialized() =>
      _channel.invokeMethod("Backendless.isInitialized");

  static Future<void> setUrl(String url) {
    _prefs.url = url;
    return _channel
        .invokeMethod("Backendless.setUrl", <String, dynamic>{"url": url});
  }

  static Future<Map<String, String>> getHeaders() async =>
      (await _channel.invokeMethod("Backendless.getHeaders"))
          .cast<String, String>();

  static Future<void> setHeader(String value,
      {String? stringKey, HeadersEnum? enumKey}) {
    checkArguments({"stringKey": stringKey}, {"enumKey": enumKey});
    _prefs.headers[value] = (stringKey != null) ? stringKey : enumKey!.header!;
    return _channel.invokeMethod("Backendless.setHeader", <String, dynamic>{
      "value": value,
      "stringKey": stringKey,
      "enumKey": enumKey?.index,
    });
  }

  static Future<void> removeHeader({String? stringKey, HeadersEnum? enumKey}) {
    checkArguments({"stringKey": stringKey}, {"enumKey": enumKey});
    String key = (stringKey != null) ? stringKey : enumKey!.header!;
    _prefs.headers.remove(key);
    return _channel.invokeMethod("Backendless.removeHeader", <String, dynamic>{
      "stringKey": stringKey,
      "enumKey": enumKey?.index,
    });
  }
}
