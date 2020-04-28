part of backendless_sdk;

abstract class Operation<T> {
  OperationType operationType;
  String table;
  String opResultId;
  T payload;

  Operation(this.operationType, this.table, this.opResultId);

  Operation.withPayload(this.operationType, this.table, this.opResultId, this.payload);

  @override
  String toString()
  {
    return "Operation{operationType=$operationType, table=$table, opResultId=$opResultId, payload=$payload}";
  }

  String toJson() => '{"operationType": "${describeEnum(operationType)}", "table": "$table", "payload" : "$payload", "opResultId": "$opResultId"}';
}

class OperationCreate extends Operation<Map> {

  OperationCreate( OperationType operationType, String table, String opResultId, Map payload ) :
    super.withPayload(operationType, table, opResultId, payload);
}

class OperationCreateBulk extends Operation<List<Map>> {
  OperationCreateBulk( OperationType operationType, String table, String opResultId, List<Map> payload ) :
        super.withPayload(operationType, table, opResultId, payload);

}

class OperationDelete extends Operation<Object> {

  OperationDelete( OperationType operationType, String table, String opResultId, Object payload ) :
        super.withPayload(operationType, table, opResultId, payload);

}

class OperationDeleteBulk extends Operation<DeleteBulkPayload> {

  OperationDeleteBulk( OperationType operationType, String table, String opResultId, DeleteBulkPayload payload ) :
        super.withPayload(operationType, table, opResultId, payload);
}

class OperationFind<T> extends Operation<T> {
  OperationFind( OperationType operationType, String table, String opResultId, T payload ) :
    super.withPayload(operationType, table, opResultId, payload);
}

class OperationAddRelation extends Operation<Relation> {

  OperationAddRelation( OperationType operationType, String table, String opResultId, Relation payload ) :
    super.withPayload(operationType, table, opResultId, payload);
  
}

class OperationDeleteRelation extends Operation<Relation> {
  OperationDeleteRelation( OperationType operationType, String table, String opResultId, Relation payload ) :

    super.withPayload(operationType, table, opResultId, payload);

}

class OperationSetRelation extends Operation<Relation> {
  OperationSetRelation( OperationType operationType, String table, String opResultId, Relation payload ) :
    super.withPayload(operationType, table, opResultId, payload);
}

class OperationUpdate extends Operation<Map> {
  OperationUpdate( OperationType operationType, String table, String opResultId, Map payload ) :
    super.withPayload(operationType, table, opResultId, payload);


}

class OperationUpdateBulk extends Operation<UpdateBulkPayload> {
  OperationUpdateBulk( OperationType operationType, String table, String opResultId, UpdateBulkPayload payload ) :
    super.withPayload(operationType, table, opResultId, payload);

}