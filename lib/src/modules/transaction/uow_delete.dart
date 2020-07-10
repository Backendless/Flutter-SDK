part of backendless_sdk;

class UnitOfWorkDelete {
  final List<Operation> operations;
  final OpResultIdGenerator opResultIdGenerator;

  UnitOfWorkDelete(this.operations, this.opResultIdGenerator);

  OpResult delete<T>(T value, [String tableName]) {
    if (value is Map) return _deleteMapInstance(tableName, value);
    if (value is String) return _deleteById(tableName, value);
    if (value is OpResult) return _deleteOpResult(value);
    if (value is OpResultValueReference) return _deleteValueRef(value);
    if (reflector.canReflect(value)) return _deleteClassInstance(value);
    throw ArgumentError(
        "The value should be either Custom class object, Map, Id, OpResult or OpResultValueReference");
  }

  OpResult _deleteClassInstance<E>(E instance) {
    Map entityMap = reflector.serialize(instance);
    String tableName = reflector.getServerName(E);

    return _deleteMapInstance(tableName, entityMap);
  }

  OpResult _deleteMapInstance(String tableName, Map objectMap) {
    String objectId = objectMap['objectId'];
    return _deleteById(tableName, objectId);
  }

  OpResult _deleteById(String tableName, String objectId) {
    String operationResultId =
        opResultIdGenerator.generateOpResultId(OperationType.DELETE, tableName);
    OperationDelete operationDelete = new OperationDelete(
        OperationType.DELETE, tableName, operationResultId, objectId);

    operations.add(operationDelete);

    return TransactionHelper.makeOpResult(
        tableName, operationResultId, OperationType.DELETE);
  }

  OpResult _deleteOpResult(OpResult result) {
    if (!OperationTypeExt.supportEntityDescriptionResultType
        .contains(result.operationType))
      throw new ArgumentError(
          "This operation result not supported in this operation");

    String operationResultId = opResultIdGenerator.generateOpResultId(
        OperationType.DELETE, result.tableName);
    OperationDelete operationDelete = new OperationDelete(
        OperationType.DELETE,
        result.tableName,
        operationResultId,
        result.resolveTo(propName: "objectId").makeReference());

    operations.add(operationDelete);

    return TransactionHelper.makeOpResult(
        result.tableName, operationResultId, OperationType.DELETE);
  }

  OpResult _deleteValueRef(OpResultValueReference resultIndex) {
    if (resultIndex.resultIndex == null || resultIndex.propName != null)
      throw new ArgumentError(
          "This operation result in this operation must resolved only to resultIndex");

    Map referenceToObjectId =
        TransactionHelper.convertCreateBulkOrFindResultIndexToObjectId(
            resultIndex);

    String operationResultId = opResultIdGenerator.generateOpResultId(
        OperationType.DELETE, resultIndex.opResult.tableName);
    OperationDelete operationDelete = new OperationDelete(OperationType.DELETE,
        resultIndex.opResult.tableName, operationResultId, referenceToObjectId);

    operations.add(operationDelete);

    return TransactionHelper.makeOpResult(resultIndex.opResult.tableName,
        operationResultId, OperationType.DELETE);
  }

  OpResult bulkDelete<T>(T value, [String tableName]) {
    if (value is List) {
      if (value[0] is Map)
        return _bulkDeleteMapInstances(tableName, value.cast<Map>());
      else if (value[0] is String)
        return _bulkDeleteByIds(tableName, value.cast<String>());
      else if (reflector.canReflect(value[0]))
        return _bulkDeleteClassInstances(value);
      else
        throw ArgumentError(
            "The value should be the list of IDs, Map or Custom Class instances");
    } else if (value is String)
      return _bulkDeleteWithQuery(tableName, value);
    else if (value is OpResult)
      return _bulkDeleteOpResult(value);
    else
      throw ArgumentError(
          "The indetifier should be either whereClause, list of IDs or OpResult");
  }

  OpResult _bulkDeleteClassInstances<E>(List<E> instances) {
    List serializedEntities =
        instances.map((E e) => reflector.serialize(e)).toList();
    String tableName = reflector.getServerName(instances[0].runtimeType);

    return _bulkDeleteMapInstances(tableName, serializedEntities);
  }

  OpResult _bulkDeleteMapInstances(String tableName, List<Map> arrayOfObjects) {
    List<Object> objectIds =
        TransactionHelper.convertMapsToObjectIds(arrayOfObjects);

    return _bulkDelete(tableName, null, objectIds);
  }

  OpResult _bulkDeleteByIds(String tableName, List<String> objectIdValues) {
    return _bulkDelete(tableName, null, objectIdValues);
  }

  OpResult _bulkDeleteWithQuery(String tableName, String whereClause) {
    return _bulkDelete(tableName, whereClause, null);
  }

  OpResult _bulkDeleteOpResult(OpResult result) {
    if (!(OperationTypeExt.supportCollectionEntityDescriptionType
            .contains(result.operationType) ||
        OperationTypeExt.supportListIdsResultType
            .contains(result.operationType)))
      throw new ArgumentError(
          "This operation result not supported in this operation");

    return _bulkDelete(result.tableName, null, result.makeReference());
  }

  OpResult _bulkDelete(
      String tableName, String whereClause, Object unconditional) {
    String operationResultId = opResultIdGenerator.generateOpResultId(
        OperationType.DELETE_BULK, tableName);
    DeleteBulkPayload deleteBulkPayload =
        new DeleteBulkPayload(whereClause, unconditional);
    OperationDeleteBulk operationDeleteBulk = new OperationDeleteBulk(
        OperationType.DELETE_BULK,
        tableName,
        operationResultId,
        deleteBulkPayload);

    operations.add(operationDeleteBulk);

    return TransactionHelper.makeOpResult(
        tableName, operationResultId, OperationType.DELETE_BULK);
  }
}
