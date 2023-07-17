part of backendless_sdk;

abstract class Operation<T> {
  OperationType? operationType;
  String? table;
  String? opResultId;
  T? payload;

  Operation(this.operationType, this.table, this.opResultId);

  Operation.withPayload(
      this.operationType, this.table, this.opResultId, this.payload) {
    if (payload is DataQueryBuilder) {
      Map mapPayload = (payload as DataQueryBuilder).toJson();
      Map relationQuery = {
        'sortBy': mapPayload['sortBy'],
        'related': (mapPayload['loadRelations'] as String).isNotEmpty
            ? (mapPayload['loadRelations'] as String).split(',')
            : [],
        'relationsDepth': mapPayload['relationsDepth'],
        'relationsPageSize': mapPayload['relationsPageSize'],
      };

      mapPayload['whereClause'] = mapPayload['where'];
      mapPayload['properties'] = mapPayload['props'];
      mapPayload['havingClause'] = mapPayload['having'];
      mapPayload['queryOptions'] = relationQuery;

      mapPayload.removeWhere((key, value) {
        return key == 'sortBy' ||
            key == 'loadRelations' ||
            key == 'relationsDepth' ||
            key == 'relationsPageSize' ||
            key == 'where' ||
            key == 'props' ||
            key == 'having';
      });
      payload = mapPayload as T;
    }
  }

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
    if (T == DeleteBulkPayload) {
      payload = DeleteBulkPayload.fromJson(json['payload']) as T;
    } else if (T == DataQueryBuilder) {
      payload = DataQueryBuilder.fromJson(json['payload']) as T;
    } else if (T == Relation) {
      payload = Relation.fromJson(json['payload']) as T;
    } else if (T == UpdateBulkPayload) {
      payload = UpdateBulkPayload.fromJson(json['payload']) as T;
    } else {
      payload = json['payload'];
    }
  }
}