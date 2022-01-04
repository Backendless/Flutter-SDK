part of backendless_sdk;

class Data {
  IDataStore<Map> of(String table) => MapDrivenDataStore(table);
}
