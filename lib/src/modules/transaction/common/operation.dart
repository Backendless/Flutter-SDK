part of backendless_sdk;

abstract class Operation<T> {
  OperationType operationType;
  String table;
  String opResultId;
  T payload;

  Operation(this.operationType, this.table, this.opResultId);

  Operation._(this.operationType, this.table, this.opResultId, this.payload);

  @override
  String toString()
  {
    return "Operation{operationType=$operationType, table=" + table + ", opResultId=" + opResultId + ", payload=$payload}";
  }

}

class OperationCreate extends Operation<Map<String, Object>> {

  OperationCreate( OperationType operationType, String table, String opResultId, Map<String, Object> payload ) :
    super._(operationType, table, opResultId, payload);
}

class OperationCreateBulk extends Operation<List<Map<String, Object>>> {
  OperationCreateBulk( OperationType operationType, String table, String opResultId, List<Map<String, Object>> payload ) :
        super._(operationType, table, opResultId, payload);

}

class OperationDelete extends Operation<Object> {

  OperationDelete( OperationType operationType, String table, String opResultId, Object payload ) :
        super._(operationType, table, opResultId, payload);

}

class OperationDeleteBulk extends Operation<DeleteBulkPayload> {

  OperationDeleteBulk( OperationType operationType, String table, String opResultId, DeleteBulkPayload payload ) :
        super._(operationType, table, opResultId, payload);
}

class OperationFind<T> extends Operation<T> {
  OperationFind( OperationType operationType, String table, String opResultId, T payload ) :
    super._(operationType, table, opResultId, payload);
}

class OperationAddRelation extends Operation<Relation> {

  OperationAddRelation( OperationType operationType, String table, String opResultId, Relation payload ) :
    super._(operationType, table, opResultId, payload);
  
}

class OperationDeleteRelation extends Operation<Relation> {
  OperationDeleteRelation( OperationType operationType, String table, String opResultId, Relation payload ) :

    super._(operationType, table, opResultId, payload);

}

class OperationSetRelation extends Operation<Relation> {
  OperationSetRelation( OperationType operationType, String table, String opResultId, Relation payload ) :
    super._(operationType, table, opResultId, payload);
}

class OperationUpdate extends Operation<Map<String, Object>> {
  OperationUpdate( OperationType operationType, String table, String opResultId, Map<String, Object> payload ) :
    super._(operationType, table, opResultId, payload);


}

class OperationUpdateBulk extends Operation<UpdateBulkPayload> {
  OperationUpdateBulk( OperationType operationType, String table, String opResultId, UpdateBulkPayload payload ) :
    super._(operationType, table, opResultId, payload);

}