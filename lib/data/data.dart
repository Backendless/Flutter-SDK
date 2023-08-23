part of backendless_sdk;

class Data {
  IDataStore<dynamic> of(String table) => MapDrivenDataStore(table);

  IDataStore<E> withClass<E>() => ClassDrivenDataStore<E>();
}
