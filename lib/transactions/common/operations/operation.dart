part of backendless_sdk;

abstract class Operation<T> {
  OperationType? operationType;
  String? table;
  String? opResultId;
  T? payload;

  Operation(this.operationType, this.table, this.opResultId);

  Operation.withPayload(
      this.operationType, this.table, this.opResultId, this.payload);

  Map toJson() => {
        "operationType": describeEnum(operationType!),
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
