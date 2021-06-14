part of backendless_sdk;

class Invoker {
  static BackendlessPrefs prefs = new BackendlessPrefs();

  static Future invoke(String methodName, body) {
    final encodedBody = _encodeBody(body);
    final url = Uri.parse(_getApplicationUrl() + "/$methodName");
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

  static String _getApplicationUrl() {
    if (prefs.appId == null)
      return "${prefs.url}/api";
    else
      return "${prefs.url}/${prefs.appId}/${prefs.apiKey}";
  }

  static String _encodeBody(dynamic body) {
    return jsonEncode(body, toEncodable: (dynamic nonEncodable) {
      if (nonEncodable is DateTime)
        return nonEncodable.toIso8601String();
      else
        return nonEncodable.toJson();
    });
  }
}
