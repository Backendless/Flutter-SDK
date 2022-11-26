part of backendless_sdk;

class OperationDeleteBulk extends Operation<DeleteBulkPayload> {
  OperationDeleteBulk(OperationType operationType, String table,
      String opResultId, DeleteBulkPayload payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationDeleteBulk.fromJson(Map json) : super.fromJson(json);
}
