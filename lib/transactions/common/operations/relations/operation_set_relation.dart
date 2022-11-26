part of backendless_sdk;

class OperationSetRelation extends Operation<Relation> {
  OperationSetRelation(OperationType operationType, String table,
      String opResultId, Relation payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationSetRelation.fromJson(Map json) : super.fromJson(json);
}
