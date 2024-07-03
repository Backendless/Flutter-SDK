part of '../../../../backendless_sdk.dart';

class OperationUpdate extends Operation<Map> {
  OperationUpdate(
      OperationType super.operationType, String super.table, String super.opResultId, Map super.payload)
      : super.withPayload();

  OperationUpdate.fromJson(super.json) : super.fromJson();
}
