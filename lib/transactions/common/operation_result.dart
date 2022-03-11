part of backendless_sdk;

class OperationResult<T> {
  OperationType? operationType;
  T? result;

  OperationResult(this.operationType, this.result);

  OperationResult.fromJson(Map json) {
    operationType = OperationType.values.firstWhere(
        (element) => describeEnum(element) == json['operationType']);
    result = json['result'];
  }
}
