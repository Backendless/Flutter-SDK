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

  void initPreferences(String applicationId, String apiKey) {
    authKeys = new AuthKeys(applicationId, apiKey);
  }

  get appId => authKeys?.applicationId;

  get apiKey => authKeys?.apiKey;
}

class AuthKeys {
  String applicationId;
  String apiKey;

  AuthKeys(this.applicationId, this.apiKey);
}
