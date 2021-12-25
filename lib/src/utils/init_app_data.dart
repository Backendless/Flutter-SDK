part of backendless_sdk;

class InitAppData {
  final String fullQueryURL;

  InitAppData._(this.fullQueryURL);

  factory InitAppData() {
    String url =
        '${Backendless._prefs.url}/${Backendless._prefs.appId}/${Backendless._prefs.apiKey}';

    return InitAppData._(url);
  }

  factory InitAppData.withDomain(String customDomain) {
    String url = customDomain;

    if (!url.endsWith('/')) url += '/';

    url += 'api';
    return InitAppData._(url);
  }
}
