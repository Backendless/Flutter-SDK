part of backendless_sdk;

class BackendlessPrefs {
  AuthKeys? authKeys;
  late Map<String, String> headers;
  late Uri url;

  static final BackendlessPrefs _instance = BackendlessPrefs._internal();

  factory BackendlessPrefs() => _instance;

  BackendlessPrefs._internal() {
    headers = {'Content-Type': 'application/json'};
    url = Uri.parse("https://api.backendless.com");
  }

  Future initPreferences(
      {String? appId, String? apiKey, String? customDomain}) async {
    if (customDomain != null) {
      if (!customDomain.startsWith('http')) {
        url = Uri.parse(customDomain);
      } else {
        url = Uri.parse('https://' + customDomain);
      }
    } else {
      authKeys = AuthKeys(appId!, apiKey!);
    }
  }

  get appId => authKeys?.appId;

  get apiKey => authKeys?.apiKey;
}
