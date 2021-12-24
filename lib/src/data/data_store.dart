part of backendless_sdk;

abstract class IDataStore<T> {
  Future<http.Response?> find({DataQueryBuilder? dataQueryBuilder});
}
