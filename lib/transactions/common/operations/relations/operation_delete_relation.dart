part of backendless_sdk;

class OperationDeleteRelation extends Operation<Relation> {
  OperationDeleteRelation(OperationType operationType, String table,
      String opResultId, Relation payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationDeleteRelation.fromJson(Map json) : super.fromJson(json);
}
