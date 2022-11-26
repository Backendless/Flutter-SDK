part of backendless_sdk;

class OperationCreate extends Operation<Map> {
  OperationCreate(
      OperationType operationType, String table, String opResultId, Map payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationCreate.fromJson(Map json) : super.fromJson(json);
}
