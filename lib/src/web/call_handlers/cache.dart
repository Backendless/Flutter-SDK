@JS()

library backendless_cache_web;

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

class CacheCallHandler {
  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {
      case "Backendless.Cache.contains":
        return promiseToFuture(contains(call.arguments['key']));
      case "Backendless.Cache.delete":
        return promiseToFuture(delete(call.arguments['key']));
      case "Backendless.Cache.expireAt":
        int timestamp = call.arguments['timestamp'];
        if (timestamp == null)
          timestamp =
              (call.arguments['date'] as DateTime).millisecondsSinceEpoch;
        return promiseToFuture(expireAt(call.arguments['key'], timestamp));
      case "Backendless.Cache.expireIn":
        return promiseToFuture(
            expireIn(call.arguments['key'], call.arguments['seconds']));
      case "Backendless.Cache.get":
        return promiseToFuture(get(call.arguments['key']))
            .then((value) => jsonDecode(value));
      case "Backendless.Cache.put":
        return promiseToFuture(put(
            call.arguments['key'],
            jsonEncode(call.arguments['object']),
            call.arguments['timeToLive']));
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

@JS('Backendless.Cache.remove')
external dynamic delete(String key);

@JS('Backendless.Cache.expireAt')
external dynamic expireAt(String key, int timestamp);

@JS('Backendless.Cache.expireIn')
external dynamic expireIn(String key, int seconds);

@JS('Backendless.Cache.get')
external dynamic get(String key);

@JS('Backendless.Cache.put')
external dynamic put(String key, dynamic object, [int timeToLive]);
