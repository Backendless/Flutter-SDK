part of backendless_sdk;

class Invoker<T> {
  static http.Client _httpClient = http.Client();

  static Future<dynamic> invoke(String method, [dynamic args]) async {
    assert(method.isNotEmpty);

    Map cleanMap = (args as DataQueryBuilder).toJson();
    cleanMap.removeWhere((key, value) {
      if (value is List && value.isEmpty) return true;

      if (value is String && value.isEmpty) return true;

      return false;
    });

    Map<String, String> params = cleanMap
        .map((key, value) => MapEntry(key.toString(), value.toString()));

    var url = Uri.https(Backendless.url.replaceFirst('https://', ''),
        '/${Backendless.applicationId}/${Backendless.apiKey}' + method, params);

    Response result = await _httpClient.get(
      url,
      headers: Backendless._prefs.headers,
    );

    return await json.decode(result.body);
  }
}
