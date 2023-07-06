part of backendless_sdk;

class BackendlessException extends io.HttpException {
  final int? code;

  BackendlessException(String message, {this.code}) : super(message);

  BackendlessException.fromJson(Map json)
      : code = json['code'],
        super(json['message']);

  @override
  String toString() => "BackendlessException: $message, code = $code";
}
