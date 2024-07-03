part of '../../../../backendless_sdk.dart';

class OperationUpdateBulk extends Operation<UpdateBulkPayload> {
  OperationUpdateBulk(OperationType super.operationType, String super.table,
      String super.opResultId, UpdateBulkPayload super.payload)
      : super.withPayload();

  OperationUpdateBulk.fromJson(super.json) : super.fromJson();
}
