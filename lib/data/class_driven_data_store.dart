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

    if (result == null) {
      result = await Invoker.put(methodName, entity);
    }

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
  Future<String?> bulkUpsert(List<E> entities) async {
    List<Map<String, dynamic>?> mapObjects =
        entities.map((entity) => reflector.serialize(entity)).toList();

    return await Invoker.put('data/bulkupsert/$tableName', mapObjects);
  }

  @override
  Future<DateTime?> remove(E entity) async {
    Map? map = reflector.serialize(entity);
    String methodName = '/data/';

    if (map == null || map.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.EMPTY_ENTITY);
    }

    String? objectId = map['objectId'];

    if (objectId?.isEmpty ?? true) {
      throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_OBJECT_ID);
    }

    methodName += '$tableName/$objectId';

    return await Invoker.delete(methodName);
  }

  @override
  Future<int?> bulkRemove(String whereClause) async {
    String methodName = '/data/bulk/$tableName';

    if (whereClause.isEmpty) {
      throw ArgumentError.value(ExceptionMessage.NULL_WHERE);
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
    if (queryBuilder == null) {
      queryBuilder = DataQueryBuilder();
    }

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
      throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_OBJECT_ID);
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
      {List? childrenObjectIds, String? whereClause}) async {
    String methodName = '/data/$tableName/$parentObjectId/$relationColumnName';
    var parameters;

    if (childrenObjectIds?.isNotEmpty ?? false) {
      parameters = childrenObjectIds;
    } else if (whereClause?.isNotEmpty ?? false) {
      methodName += '?where=$whereClause';
    }

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
  Future<List<R?>?> loadRelations<R>(String objectId,
      LoadRelationsQueryBuilder<R> relationsQueryBuilder) async {
    if (objectId.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_OBJECT_ID);
    if (relationsQueryBuilder.relationName.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_RELATION_NAME);

    List? response = await Invoker.get(
      '/data/$tableName/$objectId/${relationsQueryBuilder.relationName}',
      queryString: await toQueryString(relationsQueryBuilder),
    );

    List<R?>? result =
        response?.map((map) => reflector.deserialize<R>(map)).toList();

    return result;
  }

  @override
  Future<ClassEventHandler<E>> rt() async {
    await ClassEventHandler.initialize();

    return ClassEventHandler<E>();
  }
}
