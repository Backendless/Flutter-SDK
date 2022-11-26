part of backendless_sdk;

class OperationAddRelation extends Operation<Relation> {
  OperationAddRelation(OperationType operationType, String table,
      String opResultId, Relation payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationAddRelation.fromJson(Map json) : super.fromJson(json);
}
