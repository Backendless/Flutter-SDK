part of backendless_sdk;

class OperationUpsert extends Operation<Map> {
  OperationUpsert(
      OperationType operationType, String table, String opResultId, Map payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationUpsert.fromJson(Map json) : super.fromJson(json);
}
