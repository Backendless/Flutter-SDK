part of backendless_sdk;

abstract class IDataStore<T> {
  Future<List<Map>?>? find({DataQueryBuilder? dataQueryBuilder});
}
