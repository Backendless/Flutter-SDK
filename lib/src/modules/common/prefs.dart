part of backendless_sdk;

class BackendlessPrefs {
  AuthKeys? authKeys;
  late Map<String, String> headers;
  late String url;
  static final BackendlessPrefs _instance = BackendlessPrefs._internal();

  factory BackendlessPrefs() => _instance;

  BackendlessPrefs._internal() {
    headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    url = "https://api.backendless.com";
  }

  void initPreferences({String? appId, String? apiKey, String? customDomain}) {
    if (customDomain != null) {
      if (customDomain.startsWith("http"))
        url = customDomain;
      else
        url = "http://$customDomain";
    } else {
      authKeys = new AuthKeys(appId!, apiKey!);
    }
  }

  get appId => authKeys?.appId;

  get apiKey => authKeys?.apiKey;
}

class AuthKeys {
  String appId;
  String apiKey;

  AuthKeys(this.appId, this.apiKey);
}
