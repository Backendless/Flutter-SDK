part of backendless_sdk;

class UnitOfWorkCreate {
  final List<Operation> operations;
  final OpResultIdGenerator opResultIdGenerator;

  UnitOfWorkCreate(this.operations, this.opResultIdGenerator);

  OpResult create<T>(T instance, [String? tableName]) {
    if (instance is Map) {
      return _createMapInstance(tableName!, instance);
    } else {
      return _createClassInstance(instance);
    }
  }

  OpResult _createClassInstance<E>(E instance) {
    Map entityMap = reflector.serialize(instance)!;
    String tableName = reflector.getServerName(E)!;

    return _createMapInstance(tableName, entityMap);
  }

  OpResult _createMapInstance(String tableName, Map objectMap) {
    TransactionHelper.makeReferenceToValueFromOpResult(objectMap);

    String operationResultId =
        opResultIdGenerator.generateOpResultId(OperationType.CREATE, tableName);
    OperationCreate operationCreate = OperationCreate(
        OperationType.CREATE, tableName, operationResultId, objectMap);

    operations.add(operationCreate);

    return TransactionHelper.makeOpResult(
        tableName, operationResultId, OperationType.CREATE);
  }

  OpResult bulkCreate<T>(List<T> instances, [String? tableName]) {
    if (instances[0] is Map) {
      return _bulkCreateMapInstances(tableName!, instances.cast<Map>());
    } else {
      return _bulkCreateClassInstances(instances);
    }
  }

  OpResult _bulkCreateClassInstances<E>(List<E?> instances) {
    List<Map?> serializedEntities =
        TransactionHelper.convertInstancesToMaps(instances);

    String tableName = reflector.getServerName(E)!;

    return _bulkCreateMapInstances(tableName, serializedEntities);
  }

  OpResult _bulkCreateMapInstances(
      String tableName, List<Map?> arrayOfObjectMaps) {
    for (Map? mapObject in arrayOfObjectMaps) {
      TransactionHelper.makeReferenceToValueFromOpResult(mapObject);
    }

    String operationResultId = opResultIdGenerator.generateOpResultId(
        OperationType.CREATE_BULK, tableName);
    OperationCreateBulk operationCreateBulk = OperationCreateBulk(
        OperationType.CREATE_BULK,
        tableName,
        operationResultId,
        arrayOfObjectMaps);

    operations.add(operationCreateBulk);

    return TransactionHelper.makeOpResult(
        tableName, operationResultId, OperationType.CREATE_BULK);
  }
}
