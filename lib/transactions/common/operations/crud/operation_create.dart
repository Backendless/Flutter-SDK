part of '../../../../backendless_sdk.dart';

class OperationCreate extends Operation<Map> {
  OperationCreate(
      OperationType super.operationType, String super.table, String super.opResultId, Map super.payload)
      : super.withPayload();

  OperationCreate.fromJson(super.json) : super.fromJson();
}
