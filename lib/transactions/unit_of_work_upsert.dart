part of backendless_sdk;

class UnitOfWorkUpsert {
  final List<Operation> operations;
  final OpResultIdGenerator opResultIdGenerator;

  UnitOfWorkUpsert(this.operations, this.opResultIdGenerator);

  OpResult upsert<T>(T instance, [String? tableName]) {
    if (instance is Map)
      return _createMapInstance(tableName!, instance);
    else
      return _createClassInstance(instance);
  }

  OpResult _createClassInstance<E>(E instance) {
    Map entityMap = reflector.serialize(instance)!;
    String tableName = reflector.getServerName(E)!;

    return _createMapInstance(tableName, entityMap);
  }

  OpResult _createMapInstance(String tableName, Map objectMap) {
    TransactionHelper.makeReferenceToValueFromOpResult(objectMap);

    String operationResultId =
        opResultIdGenerator.generateOpResultId(OperationType.UPSERT, tableName);
    OperationUpsert operationUpsert = new OperationUpsert(
        OperationType.UPSERT, tableName, operationResultId, objectMap);

    operations.add(operationUpsert);

    return TransactionHelper.makeOpResult(
        tableName, operationResultId, OperationType.UPSERT);
  }

  OpResult bulkUpsert<T>(List<T> instances, [String? tableName]) {
    if (instances[0] is Map)
      return _bulkCreateMapInstances(tableName!, instances.cast<Map>());
    else
      return _bulkCreateClassInstances(instances);
  }

  OpResult _bulkCreateClassInstances<E>(List<E?> instances) {
    List<Map?> serializedEntities =
        TransactionHelper.convertInstancesToMaps(instances);

    String tableName = reflector.getServerName(E)!;

    return _bulkCreateMapInstances(tableName, serializedEntities);
  }

  OpResult _bulkCreateMapInstances(
      String tableName, List<Map?> listOfObjectMaps) {
    for (Map? mapObject in listOfObjectMaps)
      TransactionHelper.makeReferenceToValueFromOpResult(mapObject);

    String operationResultId = opResultIdGenerator.generateOpResultId(
        OperationType.UPSERT_BULK, tableName);
    OperationCreateBulk operationCreateBulk = new OperationCreateBulk(
        OperationType.UPSERT_BULK,
        tableName,
        operationResultId,
        listOfObjectMaps);

    operations.add(operationCreateBulk);

    return TransactionHelper.makeOpResult(
        tableName, operationResultId, OperationType.UPSERT_BULK);
  }
}
