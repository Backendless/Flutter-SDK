part of backendless_sdk;

class Invoker<T> {
  static http.Client httpClient = http.Client();

  static Future<http.Response?> invoke(String method, [dynamic args]) async {
    assert(method.isNotEmpty);
    var jsonBody = jsonEncode(args);

    return await httpClient.post(
      Backendless.url,
      headers: Backendless._prefs.headers,
      body: jsonBody,
    );
  }
}
