part of backendless_sdk;

class MapDrivenDataStore<T> implements IDataStore<Map> {
  final String tableName;

  const MapDrivenDataStore(this.tableName);

  @override
  Future<Map?> save(Map entity, {bool isUpsert = false}) async {
    String methodName = '/data/$tableName';

    if (isUpsert) {
      methodName += '/upsert';
    } else if (entity.containsKey('objectId')) {
      methodName += '/${entity['objectId']}';
    } else {
      return await Invoker.post(methodName, entity);
    }

    return await Invoker.put(methodName, entity);
  }

  @override
  Future<Map?> deepSave(Map map) async =>
      await Invoker.put('/data/$tableName/deep-save', map);

  @override
  Future<List<String>?> bulkCreate(List<Map> entities) async =>
      await Invoker.post('/data/bulk/$tableName', entities);

  @override
  Future<int?> bulkUpdate(String whereClause, Map changes) async {
    String methodName = '/data/bulk/$tableName';

    if (whereClause.isNotEmpty) {
      methodName += '?where=$whereClause';
    }

    return await Invoker.put(methodName, changes);
  }

  @override
  Future<List<String>?> bulkUpsert(List<Map> entities) async =>
      await Invoker.put('/data/bulkupsert/$tableName', entities);

  @override
  Future<DateTime?> remove(Map entity) async {
    String methodName = '/data/';
    if (entity.isEmpty) throw ArgumentError.value(ExceptionMessage.emptyMap);

    String? objectId = entity['objectId'];

    if (objectId?.isEmpty ?? true) {
      throw ArgumentError.value(ExceptionMessage.emptyNullObjectId);
    }

    methodName += '$tableName/$objectId';

    return await Invoker.delete(methodName);
  }

  @override
  Future<int?> bulkRemove(String whereClause) async {
    String methodName = '/data/bulk/$tableName';

    if (whereClause.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.nullWhere);
    }

    methodName += '?where=$whereClause';

    return await Invoker.delete(methodName);
  }

  @override
  Future<int?> getObjectCount({String? whereClause}) async {
    String methodName = '/data/$tableName/count';

    if (whereClause?.isNotEmpty ?? false) methodName += '?where=$whereClause';

    return await Invoker.get(methodName);
  }

  @override
  Future<List<Map>?> find({DataQueryBuilder? queryBuilder}) async {
    queryBuilder ??= DataQueryBuilder();

    return await Invoker.post<List<Map>?>(
        '/data/$tableName/find', queryBuilder);
  }

  @override
  Future<Map?> findById(String id,
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    if (id.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyNullObjectId);
    }

    queryBuilder ??= DataQueryBuilder()..loadRelations = relations;

    return await Invoker.get<Map?>('/data/$tableName/$id',
        queryString: await toQueryString(queryBuilder));
  }

  @override
  Future<Map?> findFirst(
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    var res = await Invoker.post<List<Map>?>('/data/$tableName/find',
        buildFindFirstOrLastQuery(queryBuilder, 'asc', relations: relations));

    if (res?.isNotEmpty ?? false) {
      return res![0];
    }

    return null;
  }

  @override
  Future<Map?> findLast(
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    var res = await Invoker.post<List<Map>?>('/data/$tableName/find',
        buildFindFirstOrLastQuery(queryBuilder, ' desc', relations: relations));

    if (res?.isNotEmpty ?? false) {
      return res![0];
    }

    return null;
  }

  @override
  Future<int?> addRelation(String parentObjectId, String relationColumnName,
      {List<String>? childrenObjectIds, String? whereClause}) async {
    String methodName = '/data/$tableName/$parentObjectId/$relationColumnName';
    List? parameters;

    if (childrenObjectIds?.isEmpty ?? true) {
      if (whereClause?.isEmpty ?? true) {
        throw ArgumentError.value(
            ExceptionMessage.emptyNullChildrenObjectIdsAndWhere);
      }

      methodName += '?where=$whereClause';
    }

    parameters = childrenObjectIds;

    return await Invoker.put(methodName, parameters);
  }

  @override
  Future<int?> setRelation(String parentObjectId, String relationColumnName,
      {List<String>? childrenObjectIds, String? whereClause}) async {
    String methodName = '/data/$tableName/$parentObjectId/$relationColumnName';
    List? parameters;

    if (childrenObjectIds?.isNotEmpty ?? false) {
      parameters = childrenObjectIds;
    } else if (whereClause?.isNotEmpty ?? false) {
      methodName += '?where=$whereClause';
    }

    return await Invoker.post(methodName, parameters);
  }

  @override
  Future<int?> deleteRelation(String parentObjectId, String relationColumnName,
      {List<String>? childrenObjectIds, String? whereClause}) async {
    String methodName = '/data/$tableName/$parentObjectId/$relationColumnName';
    List? parameters;

    if (childrenObjectIds?.isNotEmpty ?? false) {
      parameters = childrenObjectIds;
    } else if (whereClause?.isNotEmpty ?? false) {
      methodName += '?where=$whereClause';
    }

    return await Invoker.delete(methodName, args: parameters);
  }

  @override
  Future<List<R>?> loadRelations<R>(String objectId,
      LoadRelationsQueryBuilder<R> relationsQueryBuilder) async {
    if (objectId.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyNullObjectId);
    }
    if (relationsQueryBuilder.relationName.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyRelationName);
    }

    return await Invoker.get(
        '/data/$tableName/$objectId/${relationsQueryBuilder.relationName}',
        queryString: await toQueryString(relationsQueryBuilder));
  }

  @override
  Future<GroupResult?> group({GroupDataQueryBuilder? queryBuilder}) async {
    queryBuilder ??= GroupDataQueryBuilder();

    return await Invoker.post('/data/data-grouping/$tableName', queryBuilder);
  }

  @override
  Future<int?> getGroupObjectCount(
      {GroupDataQueryBuilder? queryBuilder}) async {
    queryBuilder ??= GroupDataQueryBuilder();

    return await Invoker.post(
        '/data/data-grouping/$tableName/count', queryBuilder);
  }

  @override
  Future<MapEventHandler<Map>> rt() async {
    await MapEventHandler.initialize();

    return MapEventHandler<Map>(tableName);
  }
}
