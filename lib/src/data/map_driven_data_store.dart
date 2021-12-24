part of backendless_sdk;

class MapDrivenDataStore implements IDataStore<Map> {
  final String tableName;

  MapDrivenDataStore(this.tableName);

  Future<http.Response?> find({DataQueryBuilder? dataQueryBuilder}) async {
    if (dataQueryBuilder == null) ;
    dataQueryBuilder = DataQueryBuilder();

    return await Invoker.invoke('find', dataQueryBuilder);
  }
}
