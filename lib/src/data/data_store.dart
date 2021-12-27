part of backendless_sdk;

abstract class IDataStore<T> {
  Future<List<Map>?>? find({DataQueryBuilder? queryBuilder});

  Future<Map?> findById(String id,
      {List<String>? relations, DataQueryBuilder? queryBuilder});

  Future<Map?> findFirst(
      {List<String> relations, DataQueryBuilder? queryBuilder});

  Future<Map?> findLast(
      {List<String>? relations, DataQueryBuilder? queryBuilder});
}
