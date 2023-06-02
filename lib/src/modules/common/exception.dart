part of backendless_sdk;

class BackendlessException extends HttpException {
  String? code;

  BackendlessException(String message, [this.code]) : super(message);

  BackendlessException.fromJson(Map json)
      : code = json['code'].toString(),
        super(json['message']);

  toJson() => {
        'code': code,
        'message': message,
      };

  String toString() => "BackendlessException: $message, code = $code";
}
