part of backendless_sdk;

class BackendlessException extends HttpException {
  int? code;

  BackendlessException(String message, [this.code]) : super(message);

  BackendlessException.fromJson(Map json)
      : code = json['code'],
        super(json['message']);

  String toString() => "BackendlessException: $message, code = $code";
}
