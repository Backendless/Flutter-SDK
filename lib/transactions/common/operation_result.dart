part of '../../backendless_sdk.dart';

class OperationResult<T> {
  OperationType? operationType;
  T? result;

  OperationResult(this.operationType, this.result);

  OperationResult.fromJson(Map json) {
    operationType = OperationType.values.firstWhere(
        (element) => element.name == json['operationType']);
    result = json['result'];
  }
}
