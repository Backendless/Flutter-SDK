part of backendless_sdk;

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