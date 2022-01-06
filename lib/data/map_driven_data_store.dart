part of backendless_sdk;

class MapDrivenDataStore implements IDataStore<Map> {
  final String tableName;

  const MapDrivenDataStore(this.tableName);

  @override
  Future<List<Map>?> find({DataQueryBuilder? queryBuilder}) async {
    if (queryBuilder == null) queryBuilder = DataQueryBuilder();

    return Invoker.post<List<Map>?>('/data/$tableName/find', queryBuilder);
  }

  @override
  Future<Map?> findById(String id,
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    if (id.isEmpty)
      throw ArgumentError.value(ExceptionMessage.EMPTY_NULL_OBJECT_ID);

    return await Invoker.get<Map?>('/data/$tableName/$id', args: queryBuilder);
  }

  @override
  Future<Map?> findFirst(
          {List<String>? relations, DataQueryBuilder? queryBuilder}) =>
      Invoker.post<List<Map>?>('/data/$tableName/find',
              _buildFindFirstOrLastQuery(queryBuilder, 'asc'))
          .then((result) => result![0]);

  @override
  Future<Map?> findLast(
          {List<String>? relations, DataQueryBuilder? queryBuilder}) =>
      Invoker.post<List<Map>?>('/data/$tableName/find',
              _buildFindFirstOrLastQuery(queryBuilder, 'desc'))
          .then((result) => result![0]);

  DataQueryBuilder _buildFindFirstOrLastQuery(
      DataQueryBuilder? queryBuilder, String sortDir) {
    DataQueryBuilder query =
        queryBuilder != null ? queryBuilder : DataQueryBuilder();

    query.pageSize = 1;
    query.offset = 0;

    if (query.sortBy == null) query.sortBy = ['created $sortDir'];

    return query;
  }
}
