part of backendless_sdk;

class ClassDrivenDataStore<E> implements IDataStore<E> {
  late String tableName;

  ClassDrivenDataStore() {
    tableName = reflector.getServerName(E)!;
  }

  @override
  Future<E?> save(E entity, {bool isUpsert = false}) async {
    Map<String, dynamic> map = reflector.serialize(entity)!;
    String methodName = '/data/$tableName';
    Map? result;

    if (isUpsert) {
      methodName += '/upsert';
    } else if (map.containsKey('objectId')) {
      methodName += '/${map['objectId']}';
    } else {
      result = await Invoker.post(methodName, entity);
    }

    result ??= await Invoker.put(methodName, map);

    return reflector.deserialize<E>(result!);
  }

  @override
  Future<E?> deepSave(E entity) async {
    Map map = reflector.serialize(entity)!;
    Map? result = await Invoker.put('/data/$tableName/deep-save', map);

    return reflector.deserialize<E>(result!);
  }

  @override
  Future<List<String>?> bulkCreate(List<E> entities) async {
    List<Map<String, dynamic>?> mapObjects =
        entities.map((entity) => reflector.serialize(entity)).toList();

    return await Invoker.post('/data/bulk/$tableName', mapObjects);
  }

  @override
  Future<int?> bulkUpdate(String whereClause, E changes) async {
    String methodName = '/data/bulk/$tableName';
    Map? mapChanges = reflector.serialize(changes);

    if (whereClause.isNotEmpty) {
      methodName += '?where=$whereClause';
    }

    return await Invoker.put(methodName, mapChanges);
  }

  @override
  Future<List<String>?> bulkUpsert(List<E> entities) async {
    List<Map<String, dynamic>?> mapObjects =
        entities.map((entity) => reflector.serialize(entity)).toList();

    return await Invoker.put('/data/bulkupsert/$tableName', mapObjects);
  }

  @override
  Future<DateTime?> remove(E entity) async {
    Map? map = reflector.serialize(entity);
    String methodName = '/data/';

    if (map == null || map.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyEntity);
    }

    String? objectId = map['objectId'];

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

    if (whereClause?.isNotEmpty ?? false) {
      methodName += '?where=$whereClause';
    }

    return await Invoker.get(methodName);
  }

  @override
  Future<List<E?>?> find({DataQueryBuilder? queryBuilder}) async {
    queryBuilder ??= DataQueryBuilder();

    List<Map>? mapObjects =
        await Invoker.post<List<Map>?>('/data/$tableName/find', queryBuilder);
    List<E?>? deserializedList =
        mapObjects?.map((map) => reflector.deserialize<E>(map)).toList();

    return deserializedList;
  }

  @override
  Future<E?> findById(String id,
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    if (id.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyNullObjectId);
    }

    Map map = (await Invoker.get<Map?>('/data/$tableName/$id',
        queryString: await toQueryString(queryBuilder)))!;

    return reflector.deserialize<E>(map);
  }

  @override
  Future<E?> findFirst(
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    Map map = (await Invoker.post<List<Map>?>('/data/$tableName/find',
        buildFindFirstOrLastQuery(queryBuilder, 'asc')))![0];

    return reflector.deserialize<E>(map);
  }

  @override
  Future<E?> findLast(
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    Map map = (await Invoker.post<List<Map>?>('/data/$tableName/find',
        buildFindFirstOrLastQuery(queryBuilder, 'desc')))![0];

    return reflector.deserialize<E>(map);
  }

  @override
  Future<int?> addRelation(String parentObjectId, String relationColumnName,
      {List<String>? childrenObjectIds, String? whereClause}) async {
    String methodName = '/data/$tableName/$parentObjectId/$relationColumnName';
    List<String>? parameters;

    if (childrenObjectIds?.isNotEmpty ?? false) {
      parameters = childrenObjectIds;
    } else if (whereClause?.isNotEmpty ?? false) {
      methodName += '?where=$whereClause';
    }

    return await Invoker.put(methodName, parameters);
  }

  @override
  Future<int?> setRelation(String parentObjectId, String relationColumnName,
      {List<String>? childrenObjectIds, String? whereClause}) async {
    String methodName = '/data/$tableName/$parentObjectId/$relationColumnName';
    List<String>? parameters;

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
    List<String>? parameters;

    if (childrenObjectIds?.isNotEmpty ?? false) {
      parameters = childrenObjectIds;
    } else if (whereClause?.isNotEmpty ?? false) {
      methodName += '?where=$whereClause';
    }

    return await Invoker.delete(methodName, args: parameters);
  }

  @override
  Future<List<R?>?> loadRelations<R>(String objectId,
      LoadRelationsQueryBuilder<R> relationsQueryBuilder) async {
    if (objectId.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyNullObjectId);
    }
    if (relationsQueryBuilder.relationName.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.emptyRelationName);
    }

    List? response = await Invoker.get(
      '/data/$tableName/$objectId/${relationsQueryBuilder.relationName}',
      queryString: await toQueryString(relationsQueryBuilder),
    );

    List<R?>? result =
        response?.map((map) => reflector.deserialize<R>(map)).toList();

    return result;
  }

  @override
  Future<GroupResult> group({GroupDataQueryBuilder? queryBuilder}) async {
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
  Future<ClassEventHandler<E>> rt() async {
    await ClassEventHandler.initialize();

    return ClassEventHandler<E>();
  }
}
