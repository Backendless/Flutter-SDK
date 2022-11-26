part of backendless_sdk;

class OperationUpdateBulk extends Operation<UpdateBulkPayload> {
  OperationUpdateBulk(OperationType operationType, String table,
      String opResultId, UpdateBulkPayload payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationUpdateBulk.fromJson(Map json) : super.fromJson(json);
}
