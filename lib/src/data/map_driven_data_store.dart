part of backendless_sdk;

class MapDrivenDataStore implements IDataStore<Map> {
  final String tableName;
  const MapDrivenDataStore(this.tableName);

  Future<List<Map>?> find({DataQueryBuilder? dataQueryBuilder}) async {
    if (dataQueryBuilder == null) ;
    dataQueryBuilder = DataQueryBuilder();

    List<dynamic> response =
        await Invoker.invoke('/data/$tableName', dataQueryBuilder);
    List<Map>? parsedResponse =
        response.map((e) => e as Map<dynamic, dynamic>).toList();

    return parsedResponse;
  }
}
