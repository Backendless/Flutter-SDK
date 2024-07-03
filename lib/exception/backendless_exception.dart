part of '../backendless_sdk.dart';

class BackendlessException extends io.HttpException {
  final int? code;

  BackendlessException(super.message, {this.code});

  BackendlessException.fromJson(Map json)
      : code = json['code'],
        super(json['message']);

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'uri': uri,
    };
  }

  @override
  String toString() => "BackendlessException: $message, code = $code";
}
