part of backendless_sdk;

class Invoker<T> {
  static http.Client httpClient = http.Client();

  static Future<dynamic> invoke(String method, [dynamic args]) async {
    assert(method.isNotEmpty);
    var jsonBody = jsonEncode(args);

    Response result = await httpClient.get(
      Uri.parse(Backendless._prefs.initAppData.fullQueryURL + method),
      headers: Backendless._prefs.headers,
    );

    return await json.decode(result.body);
  }
}
