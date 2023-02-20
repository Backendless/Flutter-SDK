part of backendless_sdk;

abstract class IDataStore<T> {
  ///If the variable `isUpsert = true`, then it calls the upsert method.
  ///Else if the object contains an objectId, the update method is called, which updates an already existing object.
  ///Otherwise, the create method will be called, which creates a new object in the table.
  Future<T?> save(T entity, {bool isUpsert = false});

  ///TODO: add doc
  Future<T?> deepSave(T entity);

  ///Creates multiple objects in the database.
  ///The API returns a list of object IDs for the objects created in the database.
  Future<List<String>?> bulkCreate(List<T> entities);

  ///This API updates multiple objects in a data table with a single request.
  ///Returns the number object of objects updated as a result of the request.
  Future<int?> bulkUpdate(String whereClause, T changes);

  ///TODO: add doc
  Future<List<T>?> bulkUpsert(List<T> entities);

  ///Removes the specified object from the database by id
  Future<DateTime?> remove(T entity);

  ///Removes multiple objects according to the described whereClause.
  ///The API returns the number of objects deleted as a result of the request.
  Future<int?> bulkRemove(String whereClause);

  ///This API returns the number of objects in a table (if the whereClause is not set),
  ///otherwise the number of objects matching the search query.
  Future<int?> getObjectCount({String? whereClause});

  ///Returns 10 objects by default from specified table
  ///You can customize this call using `DataQueryBuilder`.
  Future<List<T?>?> find({DataQueryBuilder? queryBuilder});

  ///Returns the object from the database by specified id.
  Future<T?> findById(String id,
      {List<String>? relations, DataQueryBuilder? queryBuilder});

  ///Returns the first created object in the table.
  Future<T?> findFirst(
      {List<String>? relations, DataQueryBuilder? queryBuilder});

  ///Returns the last created object in the table.
  Future<T?> findLast(
      {List<String>? relations, DataQueryBuilder? queryBuilder});

  ///The API request has 2 options:
  ///  1. Must explicitly specify child objects to add to the relation by referring to their identifiers.
  ///  2. Child objects are referenced implicitly through the whereClause clause, which defines the condition for selecting the object.
  ///
  ///At least 1 optional parameter must be defined. If 2 optional parameters are defined, 1 option is preferred.
  ///The API returns the number of objects the operation adds to the relations.
  Future<int?> addRelation(String parentObjectId, String relationColumnName,
      {List? childrenObjectIds, String? whereClause});

  ///The API request has 2 options:
  ///  1. Must explicitly specify child objects to set to the relation by referring to their identifiers.
  ///  2. Child objects are referenced implicitly through the whereClause clause, which defines the condition for selecting the object.
  ///
  ///At least 1 optional parameter must be defined. If 2 optional parameters are defined, 1 option is preferred.
  ///The API returns the number of objects the operation sets to the relations.
  Future<int?> setRelation(String parentObjectId, String relationColumnName,
      {List? childrenObjectIds, String? whereClause});

  ///The API request has 2 options:
  ///  1. Removes specific objects from a relationship by ID with their parent..
  ///  2. Deletes objects from a relationship with their parent. The objects are identified implicitly through a `whereClause` condition.
  ///
  ///At least 1 optional parameter must be defined. If 2 optional parameters are defined, 1 option is preferred.
  ///The API returns the number of child objects removed from the relationship.
  Future<int?> deleteRelation(String parentObjectId, String relationColumnName,
      {List? childrenObjectIds, String? whereClause});

  ///TODO: add doc
  Future<List<R?>?> loadRelations<R>(
      String objectId, LoadRelationsQueryBuilder<R> relationsQueryBuilder);

  Future<IEventHandler<T>> rt();
}
