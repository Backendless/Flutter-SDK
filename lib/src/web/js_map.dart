@JS()
library jsmap;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

Map jsToMap(jsObject) {
  return new Map.fromIterable(
    _getKeysOfObject(jsObject),
    value: (key) => getProperty(jsObject, key),
  );
}

dynamic mapToJs(Map mapObject) {
  Object jsObject = Object();
  mapObject.forEach((key, value) {
    setProperty(jsObject, key, value);
  });
  return jsObject;
}

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);