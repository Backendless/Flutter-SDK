part of backendless_sdk;

class Cache {
  factory Cache() => _instance;
  static final Cache _instance = Cache._internal();
  Cache._internal();

  Future<bool?> contains(String key) => Invoker.get<bool>("/cache/$key/check");

  Future<void> delete(String key) => Invoker.delete("/cache/$key");

  Future<void> expireAt(String key, {DateTime? date, int? timestamp}) =>
      Invoker.put("/cache/$key/expireAt", {'timestamp': timestamp});

  Future<void> expireIn(String key, int seconds) =>
      Invoker.put("/cache/$key/expireIn", {'timeout': seconds});

  Future<T?> get<T>(String key) => Invoker.get("/cache/$key");

  Future<void> put<T>(String key, T object, [int? timeToLive]) =>
      Invoker.put("/cache/$key", {"timeToLive": timeToLive, 'key': object});
}
