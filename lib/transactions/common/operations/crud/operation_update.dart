part of backendless_sdk;

class OperationUpdate extends Operation<Map> {
  OperationUpdate(
      OperationType operationType, String table, String opResultId, Map payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationUpdate.fromJson(Map json) : super.fromJson(json);
}
