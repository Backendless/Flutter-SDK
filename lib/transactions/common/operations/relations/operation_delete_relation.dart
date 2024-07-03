part of '../../../../backendless_sdk.dart';

class OperationDeleteRelation extends Operation<Relation> {
  OperationDeleteRelation(OperationType super.operationType, String super.table,
      String super.opResultId, Relation super.payload)
      : super.withPayload();

  OperationDeleteRelation.fromJson(super.json) : super.fromJson();
}
