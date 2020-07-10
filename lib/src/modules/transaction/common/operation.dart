part of backendless_sdk;

abstract class Operation<T> {
  OperationType operationType;
  String table;
  String opResultId;
  T payload;

  Operation(this.operationType, this.table, this.opResultId);

  Operation.withPayload(
      this.operationType, this.table, this.opResultId, this.payload);

  Map toJson() => {
        "operationType": describeEnum(operationType),
        "table": table,
        "payload": payload,
        "opResultId": opResultId,
      };

  @override
  String toString() {
    return "Operation{operationType=$operationType, table=$table, opResultId=$opResultId, payload=$payload}";
  }

  Operation.fromJson(Map json) {
    operationType = OperationType.values.firstWhere(
        (element) => describeEnum(element) == json['operationType']);
    table = json['table'];
    opResultId = json['opResultId'];
    if (T == DeleteBulkPayload)
      payload = DeleteBulkPayload.fromJson(json['payload']) as T;
    else if (T == DataQueryBuilder)
      payload = DataQueryBuilder.fromJson(json['payload']) as T;
    else if (T == Relation)
      payload = Relation.fromJson(json['payload']) as T;
    else if (T == UpdateBulkPayload)
      payload = UpdateBulkPayload.fromJson(json['payload']) as T;
    else
      payload = json['payload'];
  }
}

class OperationCreate extends Operation<Map> {
  OperationCreate(
      OperationType operationType, String table, String opResultId, Map payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationCreate.fromJson(Map json) : super.fromJson(json);
}

class OperationCreateBulk extends Operation<List> {
  OperationCreateBulk(OperationType operationType, String table,
      String opResultId, List payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationCreateBulk.fromJson(Map json) : super.fromJson(json);
}

class OperationUpdate extends Operation<Map> {
  OperationUpdate(
      OperationType operationType, String table, String opResultId, Map payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationUpdate.fromJson(Map json) : super.fromJson(json);
}

class OperationUpdateBulk extends Operation<UpdateBulkPayload> {
  OperationUpdateBulk(OperationType operationType, String table,
      String opResultId, UpdateBulkPayload payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationUpdateBulk.fromJson(Map json) : super.fromJson(json);
}

class OperationDelete extends Operation<Object> {
  OperationDelete(OperationType operationType, String table, String opResultId,
      Object payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationDelete.fromJson(Map json) : super.fromJson(json);
}

class OperationDeleteBulk extends Operation<DeleteBulkPayload> {
  OperationDeleteBulk(OperationType operationType, String table,
      String opResultId, DeleteBulkPayload payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationDeleteBulk.fromJson(Map json) : super.fromJson(json);
}

class OperationFind<T> extends Operation<T> {
  OperationFind(
      OperationType operationType, String table, String opResultId, T payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationFind.fromJson(Map json) : super.fromJson(json);
}

class OperationAddRelation extends Operation<Relation> {
  OperationAddRelation(OperationType operationType, String table,
      String opResultId, Relation payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationAddRelation.fromJson(Map json) : super.fromJson(json);
}

class OperationDeleteRelation extends Operation<Relation> {
  OperationDeleteRelation(OperationType operationType, String table,
      String opResultId, Relation payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationDeleteRelation.fromJson(Map json) : super.fromJson(json);
}

class OperationSetRelation extends Operation<Relation> {
  OperationSetRelation(OperationType operationType, String table,
      String opResultId, Relation payload)
      : super.withPayload(operationType, table, opResultId, payload);

  OperationSetRelation.fromJson(Map json) : super.fromJson(json);
}
