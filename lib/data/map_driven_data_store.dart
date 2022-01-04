part of backendless_sdk;

class MapDrivenDataStore implements IDataStore<Map> {
  final String tableName;
  const MapDrivenDataStore(this.tableName);

  Future<List<Map>?> find({DataQueryBuilder? queryBuilder}) async {
    if (queryBuilder == null) queryBuilder = DataQueryBuilder();

    return Invoker.post<List<Map>?>('/data/$tableName', queryBuilder);
  }

  Future<Map?> findById(String id,
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    if (id.isEmpty) throw ArgumentError.value(ExceptionMessage.EMPTY_OBJECT_ID);

    dynamic response = await Invoker.get('/data/$tableName/$id');
    Map? parsedResponse = response as Map;

    return parsedResponse;
  }

  @override
  Future<Map?> findFirst(
          {List<String>? relations, DataQueryBuilder? queryBuilder}) =>
      Invoker.get<Map>('/data/$tableName/first');

  @override
  Future<Map?> findLast(
          {List<String>? relations, DataQueryBuilder? queryBuilder}) =>
      Invoker.get<Map>('/data/$tableName/last');
}
