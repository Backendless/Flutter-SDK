part of backendless_sdk;

class BackendlessPrefs {
  AuthKeys? authKeys;
  late Map<String, String> headers;
  late String url;
  late InitAppData initAppData;

  static final BackendlessPrefs _instance = BackendlessPrefs._internal();

  factory BackendlessPrefs() => _instance;

  BackendlessPrefs._internal() {
    headers = {'Content-Type': 'application/json'};
    url = 'https://api.backendless.com';
  }

  Future initPreferences(
      {String? appId, String? apiKey, String? customDomain}) async {
    if (customDomain != null) {
      if (!customDomain.startsWith('http')) {
        url = customDomain;
      } else {
        url = 'https://' + customDomain;
        initAppData = InitAppData.withDomain(url);
      }
    } else {
      authKeys = AuthKeys(appId!, apiKey!);
      initAppData = InitAppData();
    }
  }

  get appId => authKeys?.appId;

  get apiKey => authKeys?.apiKey;
}
