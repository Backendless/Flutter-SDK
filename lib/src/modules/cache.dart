import 'package:flutter/services.dart';
import 'package:backendless_sdk/src/utils/utils.dart';

class BackendlessCache {
  static const MethodChannel _channel = const MethodChannel(
    'backendless/cache',
    StandardMethodCodec(BackendlessMessageCodec()));

  factory BackendlessCache() => _instance;
  static final BackendlessCache _instance = new BackendlessCache._internal();
  BackendlessCache._internal();

  Future<bool> contains(String key) async => 
    _channel.invokeMethod("Backendless.Cache.contains", <String, dynamic> {
      "key":key
    });

  void delete(String key) async => 
    _channel.invokeMethod("Backendless.Cache.delete", <String, dynamic> {
      "key":key
    });

  void expireAt(String key, {DateTime date, int timestamp}) async {
    checkArguments({"date":date}, {"timestamp":timestamp});
    _channel.invokeMethod("Backendless.Cache.expireAt", <String, dynamic> {
      "key":key,
      "date":date,
      "timestamp":timestamp
    });
  }

  void expireIn(String key, int seconds) async => 
    _channel.invokeMethod("Backendless.Cache.expireIn", <String, dynamic> { 
      "key":key,
      "seconds":seconds
    });

  /// This method does not support retrieving custom classes for now
  Future<dynamic> get(String key) async =>
    _channel.invokeMethod("Backendless.Cache.get", <String, dynamic> {
      "key":key
    });

  /// This method does not support putting custom classes for now
  void put(String key, Object object, [int timeToLive]) async =>
    _channel.invokeMethod("Backendless.Cache.put", <String, dynamic> {
      "key":key,
      "object":object,
      "timeToLive":timeToLive
    });

  ICache withKey(String key) => new CacheService(key);
}

abstract class ICache {

  Future<bool> contains();

  void delete();

  void expireAt({DateTime date, int timestamp});

  void expireIn(int seconds);

  Future<dynamic> get();

  void put(Object object, [int timeToLive]);
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
  void delete() => _cache.delete(_key);

  @override
  void expireAt({DateTime date, int timestamp}) => _cache.expireAt(_key, date: date, timestamp: timestamp);

  @override
  void expireIn(int seconds) => _cache.expireIn(_key, seconds);

  @override
  Future<dynamic> get() => _cache.get(_key);

  @override
  void put(Object object, [int timeToLive]) => _cache.put(_key, object, timeToLive);

}