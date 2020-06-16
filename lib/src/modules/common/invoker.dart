part of backendless_sdk;

class Invoker {
  static BackendlessPrefs prefs = new BackendlessPrefs();

  static Future invoke(String methodName, body) {
    final encodedBody = jsonEncode(body);
    final url = _getUrl(methodName);
    final headers = prefs.headers;

    return http.post(
      url,
      headers: headers,
      body: encodedBody,
    ).then((response) {
      if (response.statusCode >= 400) {
        try {
          throw new BackendlessException.fromJson(jsonDecode(response.body));
        } on FormatException catch (e) {
          throw new BackendlessException(response.body);
        }
      }
      return jsonDecode(response.body);
    });
  }

  static String _getUrl(String methodName) => 
    "${prefs.url}/${prefs.appId}/${prefs.apiKey}/$methodName";
  
}