part of backendless_sdk;

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