part of backendless_sdk;

class Invoker<T> {
  static final BackendlessPrefs prefs = new BackendlessPrefs();
  static final Client _httpClient = Client();
  static final Decoder decoder = Decoder();

  static Future<T?> get<T>(String methodName, {dynamic args}) async {
    String queryString = '';
    if (args != null && args is DataQueryBuilder) {
      Map<String, String> queryMap = _createQueryMap(args);
      queryString = Uri(queryParameters: queryMap).query;
    }
    final result = await _invoke(methodName + '?$queryString', Method.get);
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
    final url = Uri.parse(_getApplicationUrl() + methodName);
    final headers = prefs.headers;

    // var userToken = await BackendlessUserService._instance.getUserToken();
    // if (userToken != null) headers['user-token'] = userToken;

    Response response;

    switch (method) {
      case Method.get:
        response = await _httpClient.get(
          url,
          headers: headers,
        );
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

  static Map<String, String> _createQueryMap(DataQueryBuilder args) {
    Map cleanMap = _removeNullOrEmpty(args.toJson());
    Map<String, String> params = cleanMap
        .map((key, value) => MapEntry(key.toString(), value.toString()));

    return params;
  }

  static dynamic _removeNullOrEmpty(dynamic params) {
    if (params is Map) {
      var _map = {};
      params.forEach((key, value) {
        var _value = _removeNullOrEmpty(value);
        if (_value != null) {
          _map[key] = _value;
        }
      });
      if (_map.isNotEmpty) return _map;
    } else if (params is List) {
      var _list = [];
      for (var val in params) {
        var _value = _removeNullOrEmpty(val);
        if (_value != null) {
          _list.add(_value);
        }
      }
      if (_list.isNotEmpty) return _list;
    } else if (params != null) {
      return params;
    }
    return null;
  }
}

enum Method { get, put, post, delete }
