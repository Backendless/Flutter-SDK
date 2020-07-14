@JS()
library jsmap;

import 'dart:collection';

import 'package:js/js.dart';
import 'package:js/js_util.dart';

Map jsToMap(jsObject) {
  return new Map.fromIterable(
    _getKeysOfObject(jsObject),
    value: (key) => getProperty(jsObject, key),
  );
}

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);

dynamic convertToJs(Object object) {
  if (object == null) return null;
  if ((object is! Map) && (object is! Iterable)) {
    throw ArgumentError("object must be a Map or Iterable");
  }
  return _convertDataTree(object);
}

Object _convertDataTree(Object data) {
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
      convertedList.addAll(o.map(_convert));
      return convertedList;
    } else if (o is DateTime) {
      return o.millisecondsSinceEpoch;
    } else {
      return o;
    }
  }

  return _convert(data);
}