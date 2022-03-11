part of backendless_sdk;

class MapDrivenDataStore implements IDataStore<Map> {
  final String tableName;

  const MapDrivenDataStore(this.tableName);

  @override
  Future<Map?> save(Map entity, {bool isUpsert = false}) async {
    String methodName = '/data/$tableName';

    if (isUpsert)
      methodName += '/upsert';
    else if (entity.containsKey('objectId'))
      methodName += '/${entity['objectId']}';
    else
      return await Invoker.post(methodName, entity);

    return await Invoker.put(methodName, entity);
  }

  @override
  Future<Map?> deepSave(Map map) async {
    return await Invoker.put('/data/$tableName/deep-save', map);
  }

  Future<List<String>?> bulkCreate(List<Map> entities) async {
    return await Invoker.post('/data/bulk/$tableName', entities);
  }

  Future<int?> bulkUpdate(String whereClause, Map changes) async {
    String methodName = '/data/bulk/$tableName';

    if (whereClause.isNotEmpty) methodName += '?where=$whereClause';

    return await Invoker.put(methodName, changes);
  }

  Future<String?> bulkUpsert(List<Map> entities) async {
    return await Invoker.put('data/bulkupsert/$tableName', entities);
  }

  Future<DateTime?> remove(Map entity) async {
    String methodName = '/data/';
    if (entity.isEmpty) throw ArgumentError.value(ExceptionMessage.EMPTY_MAP);

    String? objectId = entity['objectId'];
    if (objectId?.isEmpty ?? true)
      throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_OBJECT_ID);

    methodName += '$tableName/$objectId';
    return await Invoker.delete(methodName);
  }

  Future<int?> bulkRemove(String whereClause) async {
    String methodName = '/data/bulk/$tableName';
    if (whereClause.isEmpty)
      throw ArgumentError.value(ExceptionMessage.NULL_WHERE);

    methodName += '?where=$whereClause';

    return await Invoker.delete(methodName);
  }

  Future<int?> getObjectCount({String? whereClause}) async {
    String methodName = '/data/$tableName/count';

    if (whereClause?.isNotEmpty ?? false) methodName += '?where=$whereClause';

    return await Invoker.get(methodName);
  }

  @override
  Future<List<Map>?> find({DataQueryBuilder? queryBuilder}) async {
    if (queryBuilder == null) queryBuilder = DataQueryBuilder();

    return Invoker.post<List<Map>?>('/data/$tableName/find', queryBuilder);
  }

  @override
  Future<Map?> findById(String id,
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    if (id.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_OBJECT_ID);

    return await Invoker.get<Map?>('/data/$tableName/$id',
        queryString: await toQueryString(queryBuilder));
  }

  @override
  Future<Map?> findFirst(
          {List<String>? relations, DataQueryBuilder? queryBuilder}) =>
      Invoker.post<List<Map>?>('/data/$tableName/find',
              _buildFindFirstOrLastQuery(queryBuilder, 'asc'))
          .then((result) => result![0]);

  @override
  Future<Map?> findLast(
          {List<String>? relations, DataQueryBuilder? queryBuilder}) =>
      Invoker.post<List<Map>?>('/data/$tableName/find',
              _buildFindFirstOrLastQuery(queryBuilder, 'desc'))
          .then((result) => result![0]);

  @override
  Future<int?> addRelation(String parentObjectId, String relationColumnName,
      {List? childrenObjectIds, String? whereClause}) async {
    String methodName = '/data/$tableName/$parentObjectId/$relationColumnName';
    var parameters;

    if (childrenObjectIds?.isNotEmpty ?? false)
      parameters = childrenObjectIds;
    else if (whereClause?.isNotEmpty ?? false)
      methodName += '?where=$whereClause';

    return await Invoker.put(methodName, parameters);
  }

  @override
  Future<int?> setRelation(String parentObjectId, String relationColumnName,
      {List? childrenObjectIds, String? whereClause}) async {
    String methodName = '/data/$tableName/$parentObjectId/$relationColumnName';
    var parameters;

    if (childrenObjectIds?.isNotEmpty ?? false)
      parameters = childrenObjectIds;
    else if (whereClause?.isNotEmpty ?? false)
      methodName += '?where=$whereClause';

    return await Invoker.post(methodName, parameters);
  }

  @override
  Future<int?> deleteRelation(String parentObjectId, String relationColumnName,
      {List? childrenObjectIds, String? whereClause}) async {
    String methodName = '/data/$tableName/$parentObjectId/$relationColumnName';
    var parameters;

    if (childrenObjectIds?.isNotEmpty ?? false)
      parameters = childrenObjectIds;
    else if (whereClause?.isNotEmpty ?? false)
      methodName += '?where=$whereClause';

    return await Invoker.delete(methodName, args: parameters);
  }

  @override
  Future<List<dynamic>?> loadRelations(
      String objectId, LoadRelationsQueryBuilder relationsQueryBuilder) async {
    if (objectId.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_OBJECT_ID);
    if (relationsQueryBuilder.relationName.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_RELATION_NAME);

    return await Invoker.get(
        '/data/$tableName/$objectId/${relationsQueryBuilder.relationName}',
        queryString: await toQueryString(relationsQueryBuilder));
  }

  DataQueryBuilder _buildFindFirstOrLastQuery(
      DataQueryBuilder? queryBuilder, String sortDir) {
    DataQueryBuilder query =
        queryBuilder != null ? queryBuilder : DataQueryBuilder();

    query.pageSize = 1;
    query.offset = 0;

    if (query.sortBy == null) query.sortBy = ['created $sortDir'];

    return query;
  }
}
