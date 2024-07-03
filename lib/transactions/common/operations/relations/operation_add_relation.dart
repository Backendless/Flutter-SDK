part of '../../../../backendless_sdk.dart';

class OperationAddRelation extends Operation<Relation> {
  OperationAddRelation(OperationType super.operationType, String super.table,
      String super.opResultId, Relation super.payload)
      : super.withPayload();

  OperationAddRelation.fromJson(super.json) : super.fromJson();
}
