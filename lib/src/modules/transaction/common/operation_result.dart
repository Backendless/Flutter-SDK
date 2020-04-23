part of backendless_sdk;

class OperationResult<T> {
  OperationType operationType;
  T result;

  OperationResult(this.operationType, this.result);
}