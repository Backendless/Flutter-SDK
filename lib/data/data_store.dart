part of backendless_sdk;

abstract class IDataStore<T> {
  ///Returns 10 objects by default from specified table
  ///You can customize this call using `DataQueryBuilder`.
  Future<List<Map>?>? find({DataQueryBuilder? queryBuilder});

  ///Returns the object from the database by specified id.
  Future<Map?> findById(String id,
      {List<String>? relations, DataQueryBuilder? queryBuilder});

  ///Returns the first created object in the table.
  Future<Map?> findFirst(
      {List<String> relations, DataQueryBuilder? queryBuilder});

  ///Returns the last created object in the table.
  Future<Map?> findLast(
      {List<String>? relations, DataQueryBuilder? queryBuilder});

  ///If the variable `isUpsert = true`, then it calls the upsert method.
  ///Else if the object contains an objectId, the update method is called, which updates an already existing object.
  ///Otherwise, the create method will be called, which creates a new object in the table.
  Future<Map?> save(Map map, {bool isUpsert = false});

  ///Creates multiple objects in the database.
  ///The API returns a list of object IDs for the objects created in the database.
  Future<List<String>?> bulkCreate(List<Map> entities);

  ///This API updates multiple objects in a data table with a single request.
  ///Returns the number object of objects updated as a result of the request.
  Future<int?> bulkUpdate(String whereClause, Map changes);

  ///TODO: add doc
  Future<String?> bulkUpsert(List<Map> entities);

  ///This API returns the number of objects in a table (if the whereClause is not set),
  ///otherwise the number of objects matching the search query.
  Future<int?> getObjectCount({String? whereClause});

  ///Removes the specified object from the database by id
  Future<DateTime?> remove(Map entity);

  ///Removes multiple objects according to the described whereClause.
  ///The API returns the number of objects deleted as a result of the request.
  Future<int?> bulkRemove(String whereClause);
}
