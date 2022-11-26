part of backendless_sdk;

class OperationCreateBulk extends Operation<List> {
  OperationCreateBulk(OperationType operationType, String table,
      String opResultId, List payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationCreateBulk.fromJson(Map json) : super.fromJson(json);
}
