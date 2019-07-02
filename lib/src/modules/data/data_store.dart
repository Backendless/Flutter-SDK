part of backendless_sdk;

abstract class IDataStore<E> {
  Future<int> addRelation(E parent, String relationColumnName,
      {List children, String whereClause});

  Future<List<String>> create(List<E> objects);

  Future<int> deleteRelation(E parent, String relationColumnName,
      {List children, String whereClause});

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

  Future<int> remove({Map entity, String whereClause});

  Future<E> save(E entity);

  Future<int> setRelation(E parent, String relationColumnName,
      {List children, String whereClause});

  Future<int> update(String whereClause, Map changes);

  EventHandler<E> rt();
}

class MapDataStore implements IDataStore<Map> {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/data', StandardMethodCodec(BackendlessMessageCodec()));
  String _tableName;
  EventHandler<Map> _eventHandler;

  MapDataStore(String tableName) {
    _tableName = tableName;
    _eventHandler = new EventHandler<Map>(tableName);
  }

  Future<int> addRelation(Map parent, String relationColumnName,
      {List children, String whereClause}) {
    checkArguments({"children": children}, {"whereClause": whereClause});
    return _channel
        .invokeMethod("Backendless.Data.of.addRelation", <String, dynamic>{
      'tableName': _tableName,
      'parent': parent,
      'relationColumnName': relationColumnName,
      'children': children,
      'whereClause': whereClause
    });
  }

  Future<List<String>> create(List<Map> objects) async =>
      (await _channel.invokeMethod("Backendless.Data.of.create",
              <String, dynamic>{'tableName': _tableName, 'objects': objects}))
          .cast<String>();

  Future<int> deleteRelation(Map parent, String relationColumnName,
      {List children, String whereClause}) {
    checkArguments({"children": children}, {"whereClause": whereClause});
    return _channel
        .invokeMethod("Backendless.Data.of.deleteRelation", <String, dynamic>{
      'tableName': _tableName,
      'parent': parent,
      'relationColumnName': relationColumnName,
      'children': children,
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

  Future<int> setRelation(Map parent, String relationColumnName,
      {List children, String whereClause}) {
    checkArguments({"children": children}, {"whereClause": whereClause});
    return _channel
        .invokeMethod("Backendless.Data.of.setRelation", <String, dynamic>{
      'tableName': _tableName,
      'parent': parent,
      'relationColumnName': relationColumnName,
      'children': children,
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
