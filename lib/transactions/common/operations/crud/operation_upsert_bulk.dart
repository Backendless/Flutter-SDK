part of backendless_sdk;

class OperationUpsertBulk extends Operation<List> {
  OperationUpsertBulk(OperationType operationType, String table,
      String opResultId, List payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationUpsertBulk.fromJson(Map json) : super.fromJson(json);
}
