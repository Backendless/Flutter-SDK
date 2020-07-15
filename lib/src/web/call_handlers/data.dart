@JS()

library backendless_data_web;

import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../../../backendless_sdk.dart';
import '../js_util.dart';

class DataCallHandler {
  MethodChannel _channel;

  DataCallHandler(this._channel);

  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {    
      case "Backendless.Data.describe":
        return promiseToFuture(
          describe(call.arguments['tableName'])
        ).then((value) => (convertFromJs(value) as List).map((e) => ObjectProperty.fromJson(e)).toList());
      case "Backendless.Data.of.addRelation":
        var childrenObjectIds = call.arguments['childrenObjectIds'];
        var whereClause = call.arguments['whereClause'];
        var child = childrenObjectIds != null ? childrenObjectIds : whereClause;
          return promiseToFuture(
            getDataStore(call).addRelation(call.arguments['parentObjectId'],
            call.arguments['relationColumnName'],
            child));
      case "Backendless.Data.of.create":
        return promiseToFuture(
          getDataStore(call).bulkCreate(convertToJs(call.arguments['objects']))
        );
      case "Backendless.Data.of.deleteRelation":
        var childrenObjectIds = call.arguments['childrenObjectIds'];
        var whereClause = call.arguments['whereClause'];
        var child = childrenObjectIds != null ? childrenObjectIds : whereClause;
          return promiseToFuture(
            getDataStore(call).deleteRelation(call.arguments['parentObjectId'],
            call.arguments['relationColumnName'],
            child));
      case "Backendless.Data.of.find":
        return promiseToFuture(
          getDataStore(call).find(
            getQueryBuilder(call))
        ).then((value) => convertFromJs(value));
      case "Backendless.Data.of.findById":
        return promiseToFuture(
          getDataStore(call).findById(call.arguments['id'], getQueryBuilder(call))
        ).then((value) => convertFromJs(value));
      case "Backendless.Data.of.findFirst":
        return promiseToFuture(
          getDataStore(call).findFirst(getQueryBuilder(call))
        ).then((value) => convertFromJs(value));
      case "Backendless.Data.of.findLast":
        return promiseToFuture(
          getDataStore(call).findLast(getQueryBuilder(call))
        ).then((value) => convertFromJs(value));
      case "Backendless.Data.of.getObjectCount":
      DataQueryBuilder queryBuilder = call.arguments['queryBuilder'];
        return promiseToFuture(
          getDataStore(call).getObjectCount(queryBuilder != null ? queryBuilder.whereClause : '')
        );
      case "Backendless.Data.of.loadRelations":
        return promiseToFuture(
          getDataStore(call).loadRelations(call.arguments['objectId'], getQueryBuilder(call))
        ).then((value) => convertFromJs(value));
      case "Backendless.Data.of.remove":
        var whereClause = call.arguments['whereClause'];
        var entity = convertToJs(call.arguments['entity']);
        return promiseToFuture(
          getDataStore(call).remove(whereClause != null ? whereClause : entity)
        ).then((value) => (convertFromJs(value) as Map)['deletionTime']);
      case "Backendless.Data.of.save":
        return promiseToFuture(
          getDataStore(call).save(
            convertToJs(call.arguments['entity']))
        ).then((value) => convertFromJs(value));
      case "Backendless.Data.of.setRelation":
        var childrenObjectIds = call.arguments['childrenObjectIds'];
        var whereClause = call.arguments['whereClause'];
        var child = childrenObjectIds != null ? childrenObjectIds : whereClause;
          return promiseToFuture(
            getDataStore(call).setRelation(call.arguments['parentObjectId'],
            call.arguments['relationColumnName'],
            child));
      case "Backendless.Data.of.update":
        return promiseToFuture(
          getDataStore(call).bulkUpdate(
            call.arguments['whereClause'],
            convertToJs(call.arguments['changes']))
        );
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "Backendless plugin for web doesn't implement "
              "the method '${call.method}'");
    }
  }
}

DataStoreJs getDataStore(MethodCall call) => of(call.arguments['tableName']);

dynamic getQueryBuilder(MethodCall call) {

  Map queryMap = Map();
  queryMap.addAll(call.arguments['queryBuilder']?.toJson());

  queryMap['relations'] = call.arguments['relations'];
  queryMap['relationsDepth'] = call.arguments['relationsDepth'];

  queryMap['excludeProps'] = queryMap['excludeProperties'];
  queryMap['where'] = queryMap['whereClause'];
  queryMap['having'] = queryMap['havingClause'];
  queryMap['relations'] = queryMap['related'];

  return convertToJs(queryMap);
}

@JS('Backendless.Data.describe')
external dynamic describe(String tableName);

@JS('Backendless.Data.of')
external DataStoreJs of(String tableName);


@JS('Backendless.Data.DataStore')
class DataStoreJs {
  external factory DataStoreJs(model, dataService);

  @JS()
  external int addRelation(String parentObjectId, String relationColumnName, dynamic childen);

  @JS()
  external dynamic bulkCreate(objects);

  @JS()
  external int deleteRelation(String parentObjectId, String relationColumnName, dynamic childen);

  @JS()
  external dynamic find(queryBuilder);

  @JS()
  external dynamic findById(String id, queryBuilder);

  @JS()
  external dynamic findFirst(queryBuilder);

  @JS()
  external dynamic findLast(queryBuilder);

  @JS()
  external int getObjectCount(condition);

  @JS()
  external dynamic loadRelations(String objectId, relationsQueryBuilder);

  @JS()
  external dynamic remove(object);

  @JS()
  external dynamic save(entity);

  @JS()
  external int setRelation(String parentObjectId, String relationColumnName, dynamic childen);

  @JS()
  external int bulkUpdate(condition, changes);

}