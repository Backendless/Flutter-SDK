part of backendless_sdk;

class BackendlessPrefs {
  AuthKeys _authKeys = AuthKeys();
  late Map<String, String> headers;
  late String url;

  static final BackendlessPrefs _instance = BackendlessPrefs._internal();

  factory BackendlessPrefs() => _instance;

  BackendlessPrefs._internal() {
    headers = {'Content-Type': 'application/json'};
    url = 'https://api.backendless.com';
  }

  Future initPreferences(
      {String? appId, String? apiKey, String? customDomain}) async {
    if (customDomain != null) {
      _authKeys = AuthKeys(customDomain: customDomain);
      if (!customDomain.startsWith('http')) {
        url = customDomain;
      } else {
        url = 'https://$customDomain';
      }
    } else {
      _authKeys = AuthKeys(appId: appId, apiKey: apiKey);
    }
  }

  String? get customDomain => _authKeys.customDomain;

  String? get appId => _authKeys.appId;

  String? get apiKey => _authKeys.apiKey;
}
