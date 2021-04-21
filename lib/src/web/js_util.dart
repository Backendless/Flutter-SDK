@JS()
library jsmap;

import 'dart:collection';

import 'package:js/js.dart';
import 'package:js/js_util.dart';

Object? convertFromJs(jsObject) {
  if (jsObject == null) return null;
  if (jsObject.toString() != '[object Object]' && !isArray(jsObject)) {
    throw ArgumentError("Js element must be an object or array");
  }
  return _convertDataTreeFromJs(jsObject);
}

Object _convertDataTreeFromJs(data) {
  var _convertedObjects = HashMap.identity();

  Object _convert(Object o) {
    if (_convertedObjects.containsKey(o)) {
      return _convertedObjects[o];
    }
    if (isArray(o)) {
      var convertedList = [];
      _convertedObjects[o] = convertedList;
      convertedList.addAll((o as List).map(_convert as dynamic));
      return convertedList;
    } else if (o.toString() == '[object Object]' ||
        o.runtimeType.toString() == "NativeJavaScriptObject") {
      final convertedMap = Map();
      _convertedObjects[o] = convertedMap;
      for (var key in _getKeysOfObject(o)) {
        convertedMap[key] = _convert(getProperty(o, key));
      }
      return convertedMap;
    } else {
      return o;
    }
  }

  return _convert(data);
}

dynamic convertToJs(Object object) {
  if (object == null) return null;
  if ((object is! Map) && (object is! Iterable)) {
    throw ArgumentError("object must be a Map or Iterable");
  }
  return _convertDataTreeToJs(object);
}

Object _convertDataTreeToJs(Object data) {
  var _convertedObjects = HashMap.identity();

  Object _convert(Object o) {
    if (_convertedObjects.containsKey(o)) {
      return _convertedObjects[o];
    }
    if (o is Map) {
      final convertedMap = newObject();
      _convertedObjects[o] = convertedMap;
      for (var key in o.keys) {
        setProperty(convertedMap, key, _convert(o[key]));
      }
      return convertedMap;
    } else if (o is Iterable) {
      var convertedList = [];
      _convertedObjects[o] = convertedList;
      convertedList.addAll(o.map(_convert as dynamic));
      return convertedList;
    } else if (o is DateTime) {
      return o.millisecondsSinceEpoch;
    } else {
      return o;
    }
  }

  return _convert(data);
}

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);

@JS('Array.isArray')
external bool isArray(dynamic object);
