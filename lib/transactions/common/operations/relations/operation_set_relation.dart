part of '../../../../backendless_sdk.dart';

class OperationSetRelation extends Operation<Relation> {
  OperationSetRelation(OperationType super.operationType, String super.table,
      String super.opResultId, Relation super.payload)
      : super.withPayload();

  OperationSetRelation.fromJson(super.json) : super.fromJson();
}
