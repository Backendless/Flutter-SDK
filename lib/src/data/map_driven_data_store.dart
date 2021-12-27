part of backendless_sdk;

class MapDrivenDataStore implements IDataStore<Map> {
  final String tableName;
  const MapDrivenDataStore(this.tableName);

  Future<List<Map>?> find({DataQueryBuilder? queryBuilder}) async {
    if (queryBuilder == null) queryBuilder = DataQueryBuilder();

    List<dynamic> response =
        await Invoker.invoke('/data/$tableName', queryBuilder);
    List<Map>? parsedResponse = response.map((e) => e as Map).toList();

    return parsedResponse;
  }

  Future<Map?> findById(String id,
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    if (id.isEmpty)
      throw BackendlessException(ExceptionMessage.NULL_OR_EMPTY_OBJECT_ID);

    dynamic response = await Invoker.invoke('/data/$tableName/$id');
    Map? parsedResponse = response as Map;

    return parsedResponse;
  }

  @override
  Future<Map?> findFirst(
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    dynamic response = await Invoker.invoke('/data/$tableName/first');
    Map? parsedResponse = response as Map;

    return parsedResponse;
  }

  @override
  Future<Map?> findLast(
      {List<String>? relations, DataQueryBuilder? queryBuilder}) async {
    dynamic response = await Invoker.invoke('/data/$tableName/last');
    Map? parsedResponse = response as Map;

    return parsedResponse;
  }
}
