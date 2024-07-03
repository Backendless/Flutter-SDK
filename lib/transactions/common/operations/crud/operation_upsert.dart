part of '../../../../backendless_sdk.dart';

class OperationUpsert extends Operation<Map> {
  OperationUpsert(
      OperationType super.operationType, String super.table, String super.opResultId, Map super.payload)
      : super.withPayload();

  OperationUpsert.fromJson(super.json) : super.fromJson();
}
