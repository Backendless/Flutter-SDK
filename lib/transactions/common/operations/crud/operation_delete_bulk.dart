part of '../../../../backendless_sdk.dart';

class OperationDeleteBulk extends Operation<DeleteBulkPayload> {
  OperationDeleteBulk(OperationType super.operationType, String super.table,
      String super.opResultId, DeleteBulkPayload super.payload)
      : super.withPayload();

  OperationDeleteBulk.fromJson(super.json) : super.fromJson();
}
