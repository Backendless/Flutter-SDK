part of backendless_sdk;

class OperationFind<T> extends Operation<T> {
  OperationFind(
      OperationType operationType, String table, String opResultId, T payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationFind.fromJson(Map json) : super.fromJson(json);
}
