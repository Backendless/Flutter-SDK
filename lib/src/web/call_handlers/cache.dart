@JS()

library backendless_cache_web;

import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

class CacheCallHandler {

  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {
      case "Backendless.Cache.contains":
        return promiseToFuture(
          contains(call.arguments['key']));
      // case "Backendless.Cache.delete":
      //   delete(call, result);
      //   break;
      // case "Backendless.Cache.expireAt":
      //   expireAt(call, result);
      //   break;
      // case "Backendless.Cache.expireIn":
      //   expireIn(call, result);
      //   break;
      case "Backendless.Cache.get":
        return promiseToFuture(
          get(call.arguments['key']));
      case "Backendless.Cache.put":
        return promiseToFuture(
          put(call.arguments['key'], call.arguments['object']));
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "Backendless plugin for web doesn't implement "
              "the method '${call.method}'");
    }

  }
}

@JS('Backendless.Cache.contains')
external bool contains(String key);

@JS('Backendless.Cache.put')
external dynamic put(String key, String object);

@JS('Backendless.Cache.get')
external dynamic get(String key);