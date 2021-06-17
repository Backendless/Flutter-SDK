part of backendless_sdk;

class UnitOfWorkUpdate {
  final List<Operation> operations;
  final OpResultIdGenerator opResultIdGenerator;

  UnitOfWorkUpdate(this.operations, this.opResultIdGenerator);

  OpResult update<T>(T changes, [dynamic identifier]) {
    if (changes is Map) {
      if (identifier is String) return _updateMapInstance(identifier, changes);
      if (identifier is OpResult) return _updateOpResult(identifier, changes);
      if (identifier is OpResultValueReference)
        return _updateValueRef(identifier, changes);
      throw ArgumentError(
          "The identifier should either tableName, OpResult or OpResultValueReference");
    } else {
      return _updateClassInstance(changes);
    }
  }

  OpResult _updateClassInstance<E>(E instance) {
    Map entityMap = reflector.serialize(instance)!;
    String tableName = reflector.getServerName(E)!;

    return _updateMapInstance(tableName, entityMap);
  }

  OpResult _updateMapInstance(String tableName, Map objectMap) {
    TransactionHelper.makeReferenceToValueFromOpResult(objectMap);

    String operationResultId =
        opResultIdGenerator.generateOpResultId(OperationType.UPDATE, tableName);
    OperationUpdate operationUpdate = new OperationUpdate(
        OperationType.UPDATE, tableName, operationResultId, objectMap);

    operations.add(operationUpdate);

    return TransactionHelper.makeOpResult(
        tableName, operationResultId, OperationType.UPDATE);
  }

  OpResult _updateOpResult(OpResult result, Map changes) {
    if (!OperationTypeExt.supportEntityDescriptionResultType
        .contains(result.operationType))
      throw new ArgumentError(
          "This operation result not supported in this operation");

    changes["objectId"] =
        result.resolveTo(propName: "objectId").makeReference();

    return _updateMapInstance(result.tableName, changes);
  }

  OpResult _updateValueRef(OpResultValueReference result, Map changes) {
    if (result.resultIndex == null || result.propName != null)
      throw new ArgumentError(
          "This operation result in this operation must resolved only to resultIndex");

    if (OperationTypeExt.supportCollectionEntityDescriptionType
        .contains(result.opResult.operationType))
      changes["objectId"] = result.resolveTo("objectId").makeReference();
    else if (OperationTypeExt.supportListIdsResultType
        .contains(result.opResult.operationType))
      changes["objectId"] = result.makeReference();
    else
      throw new ArgumentError(
          "This operation result not supported in this operation");

    return _updateMapInstance(result.opResult.tableName, changes);
  }

  OpResult bulkUpdate(Map changes, dynamic identifier, [String? tableName]) {
    if (identifier is String)
      return _bulkUpdateWithQuery(tableName!, identifier, changes);
    else if (identifier is List)
      return _bulkUpdateByIds(tableName!, identifier.cast<String>(), changes);
    else if (identifier is OpResult)
      return _bulkUpdateOpResult(identifier, changes);
    else
      throw ArgumentError(
          "The indetifier should be either whereClause, list of IDs or OpResult");
  }

  OpResult _bulkUpdateWithQuery(
      String tableName, String whereClause, Map changes) {
    return _bulkUpdate(tableName, whereClause, null, changes);
  }

  OpResult _bulkUpdateByIds(
      String tableName, List<String> objectsForChanges, Map changes) {
    return _bulkUpdate(tableName, null, objectsForChanges, changes);
  }

  OpResult _bulkUpdateOpResult(OpResult objectIdsForChanges, Map changes) {
    if (!(OperationTypeExt.supportCollectionEntityDescriptionType
            .contains(objectIdsForChanges.operationType) ||
        OperationTypeExt.supportListIdsResultType
            .contains(objectIdsForChanges.operationType)))
      throw new ArgumentError(
          "This operation result not supported in this operation");

    return _bulkUpdate(objectIdsForChanges.tableName, null,
        objectIdsForChanges.makeReference(), changes);
  }

  OpResult _bulkUpdate(String tableName, String? whereClause,
      Object? objectsForChanges, Map changes) {
    TransactionHelper.removeSystemField(changes);

    TransactionHelper.makeReferenceToValueFromOpResult(changes);

    String operationResultId = opResultIdGenerator.generateOpResultId(
        OperationType.UPDATE_BULK, tableName);
    UpdateBulkPayload updateBulkPayload =
        new UpdateBulkPayload(whereClause, objectsForChanges, changes);
    OperationUpdateBulk operationUpdateBulk = new OperationUpdateBulk(
        OperationType.UPDATE_BULK,
        tableName,
        operationResultId,
        updateBulkPayload);

    operations.add(operationUpdateBulk);

    return TransactionHelper.makeOpResult(
        tableName, operationResultId, OperationType.UPDATE_BULK);
  }
}
