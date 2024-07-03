part of '../../../../backendless_sdk.dart';

class OperationCreateBulk extends Operation<List> {
  OperationCreateBulk(OperationType super.operationType, String super.table,
      String super.opResultId, List super.payload)
      : super.withPayload();

  OperationCreateBulk.fromJson(super.json) : super.fromJson();
}
