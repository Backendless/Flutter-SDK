part of backendless_sdk;

class OperationDelete extends Operation<Object> {
  OperationDelete(OperationType operationType, String table, String opResultId,
      Object payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationDelete.fromJson(Map json) : super.fromJson(json);
}
