import 'package:flutter/services.dart';
import 'package:backendless_sdk/src/utils/utils.dart';

class BackendlessCache {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/cache', StandardMethodCodec(BackendlessMessageCodec()));

  factory BackendlessCache() => _instance;
  static final BackendlessCache _instance = new BackendlessCache._internal();
  BackendlessCache._internal();

  Future<bool> contains(String key) => _channel.invokeMethod(
      "Backendless.Cache.contains", <String, dynamic>{"key": key});

  Future<void> delete(String key) => _channel
      .invokeMethod("Backendless.Cache.delete", <String, dynamic>{"key": key});

  Future<void> expireAt(String key, {DateTime date, int timestamp}) {
    checkArguments({"date": date}, {"timestamp": timestamp});
    return _channel.invokeMethod("Backendless.Cache.expireAt",
        <String, dynamic>{"key": key, "date": date, "timestamp": timestamp});
  }

  Future<void> expireIn(String key, int seconds) => _channel.invokeMethod(
      "Backendless.Cache.expireIn",
      <String, dynamic>{"key": key, "seconds": seconds});

  /// This method does not support retrieving custom classes for now
  Future<dynamic> get(String key) => _channel
      .invokeMethod("Backendless.Cache.get", <String, dynamic>{"key": key});

  /// This method does not support putting custom classes for now
  Future<void> put(String key, Object object, [int timeToLive]) =>
      _channel.invokeMethod("Backendless.Cache.put", <String, dynamic>{
        "key": key,
        "object": object,
        "timeToLive": timeToLive
      });

  ICache withKey(String key) => new CacheService(key);
}

abstract class ICache {
  Future<bool> contains();

  Future<void> delete();

  Future<void> expireAt({DateTime date, int timestamp});

  Future<void> expireIn(int seconds);

  Future<dynamic> get();

  Future<void> put(Object object, [int timeToLive]);
}

class CacheService implements ICache {
  BackendlessCache _cache = new BackendlessCache();
  String _key;

  CacheService(String key) {
    _key = key;
  }

  @override
  Future<bool> contains() => _cache.contains(_key);

  @override
  Future<void> delete() => _cache.delete(_key);

  @override
  Future<void> expireAt({DateTime date, int timestamp}) =>
      _cache.expireAt(_key, date: date, timestamp: timestamp);

  @override
  Future<void> expireIn(int seconds) => _cache.expireIn(_key, seconds);

  @override
  Future<dynamic> get() => _cache.get(_key);

  @override
  Future<void> put(Object object, [int timeToLive]) =>
      _cache.put(_key, object, timeToLive);
}
