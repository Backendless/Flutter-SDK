part of '../../../../backendless_sdk.dart';

class OperationUpsertBulk extends Operation<List> {
  OperationUpsertBulk(OperationType super.operationType, String super.table,
      String super.opResultId, List super.payload)
      : super.withPayload();

  OperationUpsertBulk.fromJson(super.json) : super.fromJson();
}
