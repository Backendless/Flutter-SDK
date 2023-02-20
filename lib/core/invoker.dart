part of backendless_sdk;

class Invoker<T> {
  static final BackendlessPrefs prefs = Backendless._prefs;
  static final Client _httpClient = Client();
  static final Decoder decoder = Decoder();

  static Future<T?> get<T>(String methodName, {String? queryString}) async {
    if (queryString?.isNotEmpty ?? false) {
      queryString = '?' + queryString!.substring(0, queryString.length);
    }
    if (queryString == null) queryString = '';

    final result = await _invoke(methodName + queryString, Method.get);
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
    final encodedBody = args != null ? await _encodeBody(args) : null;
    final url = Uri.parse(_getApplicationUrl() + methodName);
    final headers = prefs.headers;

    if ((await Backendless.userService.loginStorage)._hasData) {
      headers['user-token'] =
          (await Backendless.userService.loginStorage)._userToken!;
    }

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
    if (response.body.isEmpty) return;

    return jsonDecode(response.body);
  }

  static String _getApplicationUrl() {
    if (prefs.appId == null) {
      return "${prefs.url}/api";
    } else {
      return "${prefs.url}/${prefs.appId}/${prefs.apiKey}";
    }
  }

  static Future<String> _encodeBody(dynamic body) async {
    return jsonEncode(body, toEncodable: (dynamic nonEncodable) {
      if (nonEncodable is DateTime) {
        return nonEncodable.toIso8601String();
      }
      // if (nonEncodable is DataQueryBuilder) {
      //   return await toQueryString(nonEncodable);
      // }
      else {
        return nonEncodable.toJson();
      }
    });
  }

  /*static Map<String, String> _createQueryMap(DataQueryBuilder args) {
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
  }*/

  static Future _invokeCustomService(String methodName, body,
      {InvokeOptions? options}) async {
    final encodedBody = await _encodeBody(body);
    final url = Uri.parse(_getApplicationUrl() + "/$methodName");
    final headers = prefs.headers;

    if (options != null) {
      if (options.executionType != null)
        headers['bl-execution-type'] = describeEnum(options.executionType!);
      if (options.httpRequestHeaders != null)
        headers.addAll(options.httpRequestHeaders!);
    }

    if ((await Backendless.userService.loginStorage)._hasData) {
      headers['user-token'] =
          (await Backendless.userService.loginStorage)._userToken!;
    }

    return _httpClient
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
      return jsonDecode(utf8.decode(response.bodyBytes));
    });
  }
}

enum Method { get, put, post, delete }
