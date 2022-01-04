part of backendless_sdk;

class Invoker<T> {
  static final BackendlessPrefs prefs = new BackendlessPrefs();
  static final Client _httpClient = Client();
  static final Decoder decoder = Decoder();

  static Future<T?> get<T>(String methodName) async {
    final result = await _invoke(methodName, Method.get);
    return decoder.decode<T>(result);
  }

  static Future<T?> put<T>(String methodName, dynamic args) async {
    final result = await _invoke(methodName, Method.put, args: args);
    return decoder.decode<T>(result);
  }

  static Future<T?> post<T>(String methodName, dynamic args) async {
    final result = await _invoke(methodName, Method.post, args: args);
    return decoder.decode<T>(result);
  }

  static Future<T?> delete<T>(String methodName, {dynamic args}) async {
    final result = await _invoke(methodName, Method.delete, args: args);
    return decoder.decode<T>(result);
  }

  static Future _invoke(String methodName, Method method,
      {dynamic args}) async {
    final encodedBody = _encodeBody(args);
    final url = Uri.parse(_getApplicationUrl() + "/$methodName");
    final headers = prefs.headers;

    // var userToken = await BackendlessUserService._instance.getUserToken();
    // if (userToken != null) headers['user-token'] = userToken;

    Response response;

    switch (method) {
      case Method.get:
        response = await _httpClient.get(url, headers: headers);
        break;

      case Method.put:
        response =
            await _httpClient.put(url, headers: headers, body: encodedBody);
        break;

      case Method.post:
        response =
            await _httpClient.post(url, headers: headers, body: encodedBody);
        break;

      case Method.delete:
        response =
            await _httpClient.delete(url, headers: headers, body: encodedBody);
        break;
    }
    if (response.statusCode >= 400) {
      try {
        throw BackendlessException.fromJson(jsonDecode(response.body));
      } on FormatException {
        throw BackendlessException(response.body);
      }
    }
    return jsonDecode(response.body);
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

enum Method { get, put, post, delete }
