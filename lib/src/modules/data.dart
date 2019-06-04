import 'package:flutter/services.dart';
import 'package:backendless_sdk/src/utils/utils.dart';

class BackendlessData {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/data', StandardMethodCodec(BackendlessMessageCodec()));
  static final Map<int, DataSubscription> _subscriptions =
      <int, DataSubscription>{};

  factory BackendlessData() => _instance;
  static final BackendlessData _instance = new BackendlessData._internal();

  BackendlessData._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method.contains("EventResponse")) {
        Map<dynamic, dynamic> arguments = call.arguments;

        switch (call.method) {
          case ("Backendless.Data.RT.EventResponse"):
            int handle = arguments["handle"];
            var response = arguments["response"];
            _subscriptions[handle].handleResponse(response);
            break;
          case ("Backendless.Data.RT.EventFault"):
            int handle = arguments["handle"];
            String fault = call.arguments["fault"];
            _subscriptions[handle].handleFault(fault);
            break;
        }
      }
    });
  }

  IDataStore<Map> of(String tableName) => new MapDataStore(tableName);

  Future<Map> callStoredProcedure(
          String procedureName, Map<String, Object> arguments) =>
      _channel.invokeMethod(
          "Backendless.Data.callStoredProcedure", <String, dynamic>{
        'procedureName': procedureName,
        'arguments': arguments
      });

  Future<List<String>> create({List<Object> objects, Type type, Map entity}) {
    checkArguments({"objects": objects}, {"type": type, "entity": entity});
    if (objects != null) {
      // create with objects
      throw new UnimplementedError();
    } else {
      // create with type&entity
      throw new UnimplementedError();
    }
  }

  Future<List<ObjectProperty>> describe(String classSimpleName) async =>
      (await _channel.invokeMethod("Backendless.Data.describe",
              <String, dynamic>{'classSimpleName': classSimpleName}))
          .cast<ObjectProperty>();

  Future<List<Object>> find(Type entity, DataQueryBuilder queryBuilder) =>
      throw new UnimplementedError();

  Future<Map<String, Object>> getView(
          String viewName, DataQueryBuilder queryBuilder) async =>
      (await _channel.invokeMethod(
              "Backendless.Data.getView", <String, dynamic>{
        'viewName': viewName,
        'queryBuilder': queryBuilder
      }))
          .cast<String, Object>();

  Future<List<Object>> loadRelations(String parentType, String objectId,
          LoadRelationsQueryBuilder queryBuilder, Type relatedType) =>
      throw new UnimplementedError();

  void mapTableToClass(String tableName, Type type) =>
      throw new UnimplementedError();

  Future<E> save<E>(E entity) => throw new UnimplementedError();
}

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

class EventHandler<T> {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/data', StandardMethodCodec(BackendlessMessageCodec()));
  String _tableName;

  EventHandler(this._tableName);

// Create

  void addCreateListener(void callback(T response),
      {void onError(String error), String whereClause}) {
    DataSubscription<T> subscription = new DataSubscription<T>(
        RTDataEvent.CREATED, _tableName, callback, onError, whereClause);
    addEventListener(subscription);
  }

  void removeCreateListeners() {
    _removeListeners(RTDataEvent.CREATED);
  }

  void removeCreateListener({String whereClause, void callback(T response)}) {
    _removeListeners(RTDataEvent.CREATED, whereClause, callback);
  }

// Update

  void addUpdateListener(void callback(T response),
      {void onError(String error), String whereClause}) {
    DataSubscription subscription = new DataSubscription(
        RTDataEvent.UPDATED, _tableName, callback, onError, whereClause);
    addEventListener(subscription);
  }

  void removeUpdateListeners() {
    _removeListeners(RTDataEvent.UPDATED);
  }

  void removeUpdateListener({String whereClause, void callback(T response)}) {
    _removeListeners(RTDataEvent.UPDATED, whereClause, callback);
  }

// Delete

  void addDeleteListener(void callback(T response),
      {void onError(String error), String whereClause}) {
    DataSubscription subscription = new DataSubscription(
        RTDataEvent.DELETED, _tableName, callback, onError, whereClause);
    addEventListener(subscription);
  }

  void removeDeleteListeners() {
    _removeListeners(RTDataEvent.DELETED);
  }

  void removeDeleteListener({String whereClause, void callback(T response)}) {
    _removeListeners(RTDataEvent.DELETED, whereClause, callback);
  }

// Bulk Update

  void addBulkUpdateListener(void callback(BulkEvent response),
      {void onError(String error), String whereClause}) {
    DataSubscription subscription = new DataSubscription(
        RTDataEvent.BULK_UPDATED, _tableName, callback, onError, whereClause);
    addEventListener(subscription);
  }

  void removeBulkUpdateListeners() {
    _removeListeners(RTDataEvent.BULK_UPDATED);
  }

  void removeBulkUpdateListener(
      {String whereClause, void callback(BulkEvent response)}) {
    _removeListeners(RTDataEvent.BULK_UPDATED, whereClause, callback);
  }

// Bulk Delete

  void addBulkDeleteListener(void callback(BulkEvent response),
      {void onError(String error), String whereClause}) {
    DataSubscription subscription = new DataSubscription(
        RTDataEvent.BULK_DELETED, _tableName, callback, onError, whereClause);
    addEventListener(subscription);
  }

  void removeBulkDeleteListeners() {
    _removeListeners(RTDataEvent.BULK_DELETED);
  }

  void removeBulkDeleteListener(
      {String whereClause, void callback(BulkEvent response)}) {
    _removeListeners(RTDataEvent.BULK_DELETED, whereClause, callback);
  }

  void addEventListener(DataSubscription subscription) {
    _channel.invokeMethod("Backendless.Data.RT.addListener", <String, dynamic>{
      "event": subscription.event.toString(),
      "tableName": subscription.tableName,
      "whereClause": subscription.whereClause
    }).then((handle) => BackendlessData._subscriptions[handle] = subscription);
  }

  void _removeListeners(RTDataEvent event,
      [String whereClause, Function callback]) {
    List<int> toRemove = [];
    BackendlessData._subscriptions.forEach((handle, subscription) {
      if (subscription.event == event &&
          (whereClause == null || whereClause == subscription.whereClause) &&
          (callback == null || callback == subscription.handleResponse)) {
        toRemove.add(handle);
      }
    });

    toRemove.forEach((handle) {
      _channel
          .invokeMethod("Backendless.Data.RT.removeListener", <String, dynamic>{
        "handle": handle,
        "event": event.toString(),
        "tableName": _tableName,
        "whereClause": whereClause
      });
      BackendlessData._subscriptions.remove(handle);
    });
  }
}

class DataSubscription<T> {
  RTDataEvent event;
  String tableName;
  Function handleResponse;
  void Function(String fault) _handleFault;
  String whereClause;

  DataSubscription(
      this.event, this.tableName, this.handleResponse, this._handleFault,
      [this.whereClause]);

  void handleFault(String fault) {
    if (_handleFault != null) _handleFault(fault);
  }
}

abstract class AbstractProperty {
  String name;
  bool required;
  DateTypeEnum type;

  AbstractProperty({this.name, this.required = false, this.type});
}

class ObjectProperty extends AbstractProperty {
  String relatedTable;
  Object defaultValue;

  ObjectProperty();

  ObjectProperty.fromJson(Map json) {
    relatedTable = json['relatedTable'];
    defaultValue = json['defaultValue'];
    name = json['name'];
    required = json['required'];
    type = DateTypeEnum.values[json['type']];
  }

  Map toJson() =>
    {
      'relatedTable': relatedTable,
      'defaultValue': defaultValue,
      'name': name,
      'required': required,
      'type': type?.index,
    };
}

class BulkEvent {
  String whereClause;
  int count;

  BulkEvent();

  BulkEvent.fromJson(Map json) : 
    whereClause = json['whereClause'],
    count = json['count'];

  Map toJson() =>
    {
      'whereClause': whereClause,
      'count': count,
    };

  @override
  String toString() => "BulkEvent{whereClause='$whereClause', count=$count}";
}

enum DateTypeEnum {
  UNKNOWN,
  INT,
  STRING,
  BOOLEAN,
  DATETIME,
  DOUBLE,
  RELATION,
  COLLECTION,
  RELATION_LIST,
  STRING_ID,
  TEXT
}

enum RTDataEvent {
  CREATED,
  BULK_CREATED,
  UPDATED,
  BULK_UPDATED,
  DELETED,
  BULK_DELETED
}
