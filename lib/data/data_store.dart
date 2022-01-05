part of backendless_sdk;

abstract class IDataStore<T> {
  ///Returns 10 objects by default from specified table
  ///You can customize this call using DataQueryBuilder
  Future<List<Map>?>? find({DataQueryBuilder? queryBuilder});

  Future<Map?> findById(String id,
      {List<String>? relations, DataQueryBuilder? queryBuilder});

  Future<Map?> findFirst(
      {List<String> relations, DataQueryBuilder? queryBuilder});

  Future<Map?> findLast(
      {List<String>? relations, DataQueryBuilder? queryBuilder});
}
