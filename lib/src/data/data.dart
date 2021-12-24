part of backendless_sdk;

class BackendlessData {
  IDataStore<Map> of(String table) => MapDrivenDataStore(table);
}
