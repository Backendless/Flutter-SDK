part of '../../../../backendless_sdk.dart';

class OperationDelete extends Operation<Object> {
  OperationDelete(OperationType super.operationType, String super.table, String super.opResultId,
      Object super.payload)
      : super.withPayload();

  OperationDelete.fromJson(super.json) : super.fromJson();
}
