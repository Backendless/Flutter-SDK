part of backendless_sdk;

class Invoker {
  static BackendlessPrefs prefs = new BackendlessPrefs();

  static Future invoke(String methodName, body) {
    final encodedBody = _encodeBody(body);
    final url = _getUrl(methodName);
    final headers = prefs.headers;

    return http
        .post(
      url,
      headers: headers,
      body: encodedBody,
    )
        .then((response) {
      if (response.statusCode >= 400) {
        try {
          throw new BackendlessException.fromJson(jsonDecode(response.body));
        } on FormatException {
          throw new BackendlessException(response.body);
        }
      }
      return jsonDecode(response.body);
    });
  }

  static Uri _getUrl(String methodName) =>
      Uri.parse("${prefs.url}/${prefs.appId}/${prefs.apiKey}/$methodName");

  static String _encodeBody(dynamic body) {
    return jsonEncode(body, toEncodable: (dynamic nonEncodable) {
      if (nonEncodable is DateTime)
        return nonEncodable.toIso8601String();
      else
        return nonEncodable.toJson();
    });
  }
}
