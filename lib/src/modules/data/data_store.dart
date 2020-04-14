part of backendless_sdk;

abstract class IDataStore<E> {
  Future<int> addRelation(String parentObjectId, String relationColumnName,
      {List<String> childrenObjectIds, String whereClause});

  Future<List<String>> create(List<E> objects);

  Future<int> deleteRelation(String parentObjectId, String relationColumnName,
      {List<String> childrenObjectIds, String whereClause});

  Future<List<E>> find([DataQueryBuilder queryBuilder]);

  Future<E> findById(String id,
      {List<String> relations,
      int relationsDepth,
      DataQueryBuilder queryBuilder});

  Future<E> findFirst({List<String> relations, int relationsDepth});

  Future<E> findLast({List<String> relations, int relationsDepth});

  Future<int> getObjectCount([DataQueryBuilder queryBuilder]);

  Future<List<R>> loadRelations<R>(
      String objectId, LoadRelationsQueryBuilder<R> queryBuilder);

  Future<int> remove({E entity, String whereClause});

  Future<E> save(E entity);

  Future<int> setRelation(String parentObjectId, String relationColumnName,
      {List<String> childrenObjectIds, String whereClause});

  Future<int> update(String whereClause, Map changes);

  EventHandler<E> rt();
}

class MapDrivenDataStore implements IDataStore<Map> {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/data', StandardMethodCodec(BackendlessMessageCodec()));
  String _tableName;
  EventHandler<Map> _eventHandler;

  MapDrivenDataStore(String tableName) {
    _tableName = tableName;
    _eventHandler = new EventHandler<Map>(tableName);
  }

  Future<int> addRelation(String parentObjectId, String relationColumnName,
      {List<String> childrenObjectIds, String whereClause}) {
    checkArguments({"childrenObjectIds": childrenObjectIds}, {"whereClause": whereClause});
    return _channel
        .invokeMethod("Backendless.Data.of.addRelation", <String, dynamic>{
      'tableName': _tableName,
      'parentObjectId': parentObjectId,
      'relationColumnName': relationColumnName,
      'childrenObjectIds': childrenObjectIds,
      'whereClause': whereClause
    });
  }

  Future<List<String>> create(List<Map> objects) async =>
      (await _channel.invokeMethod("Backendless.Data.of.create",
              <String, dynamic>{'tableName': _tableName, 'objects': objects}))
          .cast<String>();

  Future<int> deleteRelation(String parentObjectId, String relationColumnName,
      {List<String> childrenObjectIds, String whereClause}) {
    checkArguments({"childrenObjectIds": childrenObjectIds}, {"whereClause": whereClause});
    return _channel
        .invokeMethod("Backendless.Data.of.deleteRelation", <String, dynamic>{
      'tableName': _tableName,
      'parentObjectId': parentObjectId,
      'relationColumnName': relationColumnName,
      'childrenObjectIds': childrenObjectIds,
      'whereClause': whereClause
    });
  }

  Future<List<Map>> find([DataQueryBuilder queryBuilder]) async =>
      (await _channel.invokeMethod(
              "Backendless.Data.of.find", <String, dynamic>{
        'tableName': _tableName,
        'queryBuilder': queryBuilder
      }))
          .cast<Map>();

  Future<Map> findById(String id,
      {List<String> relations,
      int relationsDepth,
      DataQueryBuilder queryBuilder}) {
    checkArguments({
      "relations": relations,
      "relationsDepth": relationsDepth
    }, {
      "queryBuilder": queryBuilder
    }, isRequired: false);
    return _channel
        .invokeMethod("Backendless.Data.of.findById", <String, dynamic>{
      'tableName': _tableName,
      'id': id,
      'relations': relations,
      'relationsDepth': relationsDepth,
      'queryBuilder': queryBuilder
    });
  }

  Future<Map> findFirst({List<String> relations, int relationsDepth}) {
    checkArguments({"relations": relations}, {"relationsDepth": relationsDepth},
        isRequired: false);
    return _channel
        .invokeMethod("Backendless.Data.of.findFirst", <String, dynamic>{
      'tableName': _tableName,
      'relations': relations,
      'relationsDepth': relationsDepth,
    });
  }

  Future<Map> findLast({List<String> relations, int relationsDepth}) {
    checkArguments({"relations": relations}, {"relationsDepth": relationsDepth},
        isRequired: false);
    return _channel
        .invokeMethod("Backendless.Data.of.findLast", <String, dynamic>{
      'tableName': _tableName,
      'relations': relations,
      'relationsDepth': relationsDepth,
    });
  }

  Future<int> getObjectCount([DataQueryBuilder queryBuilder]) => _channel
          .invokeMethod("Backendless.Data.of.getObjectCount", <String, dynamic>{
        'tableName': _tableName,
        'queryBuilder': queryBuilder
      });

  Future<List<R>> loadRelations<R>(
          String objectId, LoadRelationsQueryBuilder<R> queryBuilder) async =>
      (await _channel.invokeMethod(
              "Backendless.Data.of.loadRelations", <String, dynamic>{
        'tableName': _tableName,
        'objectId': objectId,
        'queryBuilder': queryBuilder,
      }))
          .cast<R>();

  Future<int> remove({Map entity, String whereClause}) {
    checkArguments({"entity": entity}, {"whereClause": whereClause});
    return _channel.invokeMethod(
        "Backendless.Data.of.remove", <String, dynamic>{
      'tableName': _tableName,
      'entity': entity,
      'whereClause': whereClause
    });
  }

  Future<Map> save(Map entity) =>
      _channel.invokeMethod("Backendless.Data.of.save", <String, dynamic>{
        'tableName': _tableName,
        'entity': entity,
      });

  Future<int> setRelation(String parentObjectId, String relationColumnName,
      {List<String> childrenObjectIds, String whereClause}) {
    checkArguments({"childrenObjectIds": childrenObjectIds}, {"whereClause": whereClause});
    return _channel
        .invokeMethod("Backendless.Data.of.setRelation", <String, dynamic>{
      'tableName': _tableName,
      'parentObjectId': parentObjectId,
      'relationColumnName': relationColumnName,
      'childrenObjectIds': childrenObjectIds,
      'whereClause': whereClause
    });
  }

  Future<int> update(String whereClause, Map changes) =>
      _channel.invokeMethod("Backendless.Data.of.update", <String, dynamic>{
        'tableName': _tableName,
        'whereClause': whereClause,
        'changes': changes
      });

  EventHandler<Map> rt() => _eventHandler;
}

class ClassDrivenDataStore<T> implements IDataStore<T> {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/data', StandardMethodCodec(BackendlessMessageCodec()));
  String _tableName;
  EventHandler<T> _eventHandler;

  ClassDrivenDataStore() {
    _tableName = reflector.getServerName(T);
    _eventHandler = new EventHandler<T>(_tableName);
  }

  Future<int> addRelation(String parentObjectId, String relationColumnName,
      {List<String> childrenObjectIds, String whereClause}) {
    checkArguments({"childrenObjectIds": childrenObjectIds}, {"whereClause": whereClause});
    return _channel
        .invokeMethod("Backendless.Data.of.addRelation", <String, dynamic>{
      'tableName': _tableName,
      'parentObjectId': parentObjectId,
      'relationColumnName': relationColumnName,
      'childrenObjectIds': childrenObjectIds,
      'whereClause': whereClause
    });
  }

  Future<List<String>> create(List<T> objects) async {
    List<Map<String, dynamic>> mapObjects =
        objects.map((object) => reflector.serialize(object)).toList();
    return (await _channel.invokeMethod("Backendless.Data.of.create",
            <String, dynamic>{'tableName': _tableName, 'objects': mapObjects}))
        .cast<String>();
  }

  Future<int> deleteRelation(String parentObjectId, String relationColumnName,
      {List<String> childrenObjectIds, String whereClause}) {
    checkArguments({"childrenObjectIds": childrenObjectIds}, {"whereClause": whereClause});
    return _channel
        .invokeMethod("Backendless.Data.of.deleteRelation", <String, dynamic>{
      'tableName': _tableName,
      'parentObjectId': parentObjectId,
      'relationColumnName': relationColumnName,
      'childrenObjectIds': childrenObjectIds,
      'whereClause': whereClause
    });
  }

  Future<List<T>> find([DataQueryBuilder queryBuilder]) async {
    List<Map> mapObjects = (await _channel.invokeMethod(
            "Backendless.Data.of.find", <String, dynamic>{
      'tableName': _tableName,
      'queryBuilder': queryBuilder
    }))
        .cast<Map>();

    List<T> deserializedList =
        mapObjects.map((map) => reflector.deserialize<T>(map)).toList();

    return Future<List<T>>.value(deserializedList);
  }

  Future<T> findById(String id,
      {List<String> relations,
      int relationsDepth,
      DataQueryBuilder queryBuilder}) async {
    checkArguments({
      "relations": relations,
      "relationsDepth": relationsDepth
    }, {
      "queryBuilder": queryBuilder
    }, isRequired: false);
    Map mapObject = await _channel
        .invokeMethod("Backendless.Data.of.findById", <String, dynamic>{
      'tableName': _tableName,
      'id': id,
      'relations': relations,
      'relationsDepth': relationsDepth,
      'queryBuilder': queryBuilder
    });

    return reflector.deserialize<T>(mapObject);
  }

  Future<T> findFirst({List<String> relations, int relationsDepth}) async {
    checkArguments({"relations": relations}, {"relationsDepth": relationsDepth},
        isRequired: false);
    Map mapObject = await _channel
        .invokeMethod("Backendless.Data.of.findFirst", <String, dynamic>{
      'tableName': _tableName,
      'relations': relations,
      'relationsDepth': relationsDepth,
    });

    return reflector.deserialize<T>(mapObject);
  }

  Future<T> findLast({List<String> relations, int relationsDepth}) async {
    checkArguments({"relations": relations}, {"relationsDepth": relationsDepth},
        isRequired: false);
    Map mapObject = await _channel
        .invokeMethod("Backendless.Data.of.findLast", <String, dynamic>{
      'tableName': _tableName,
      'relations': relations,
      'relationsDepth': relationsDepth,
    });

    return reflector.deserialize<T>(mapObject);
  }

  Future<int> getObjectCount([DataQueryBuilder queryBuilder]) => _channel
          .invokeMethod("Backendless.Data.of.getObjectCount", <String, dynamic>{
        'tableName': _tableName,
        'queryBuilder': queryBuilder
      });

  Future<List<R>> loadRelations<R>(
      String objectId, LoadRelationsQueryBuilder<R> queryBuilder) async {
    List response = (await _channel
        .invokeMethod("Backendless.Data.of.loadRelations", <String, dynamic>{
      'tableName': _tableName,
      'objectId': objectId,
      'queryBuilder': queryBuilder,
    }));
    List<R> result =
        response.map((map) => reflector.deserialize<R>(map)).toList();
    return result;
  }

  Future<int> remove({T entity, String whereClause}) {
    checkArguments({"entity": entity}, {"whereClause": whereClause});
    return _channel
        .invokeMethod("Backendless.Data.of.remove", <String, dynamic>{
      'tableName': _tableName,
      'entity': reflector.serialize(entity),
      'whereClause': whereClause
    });
  }

  Future<T> save(T entity) async {
    Map mapObject = await _channel.invokeMethod(
        "Backendless.Data.of.save", <String, dynamic>{
      'tableName': _tableName,
      'entity': reflector.serialize(entity)
    });
    return reflector.deserialize<T>(mapObject);
  }

  Future<int> setRelation(String parentObjectId, String relationColumnName,
      {List<String> childrenObjectIds, String whereClause}) {
    checkArguments({"childrenObjectIds": childrenObjectIds}, {"whereClause": whereClause});
    return _channel
        .invokeMethod("Backendless.Data.of.setRelation", <String, dynamic>{
      'tableName': _tableName,
      'parentObjectId': parentObjectId,
      'relationColumnName': relationColumnName,
      'childrenObjectIds': childrenObjectIds,
      'whereClause': whereClause
    });
  }

  Future<int> update(String whereClause, Map changes) =>
      _channel.invokeMethod("Backendless.Data.of.update", <String, dynamic>{
        'tableName': _tableName,
        'whereClause': whereClause,
        'changes': changes
      });

  EventHandler<T> rt() => _eventHandler;
}
