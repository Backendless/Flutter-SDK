part of '../../backendless_sdk.dart';

class BackendlessExpression {
  final String ___class = 'BackendlessExpression';
  final String value;

  BackendlessExpression._(this.value);

  factory BackendlessExpression(String value) {
    if (value.isEmpty) {
      throw BackendlessException(ExceptionMessage.emptyBackendlessExpression);
    }

    return BackendlessExpression._(value);
  }

  Map toJson() => {
        '___class': ___class,
        'value': value,
      };
}
