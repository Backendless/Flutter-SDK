part of backendless_sdk;

class UnitOfWork {
  static const String referenceMarker = "___ref";
  static const String opResultId = "opResultId";
  static const String resultIndex = "resultIndex";
  static const String propName = "propName";

  late UnitOfWorkCreate _unitOfWorkCreate;
  late UnitOfWorkUpdate _unitOfWorkUpdate;
  late UnitOfWorkUpsert _unitOfWorkUpsert;
  late UnitOfWorkDelete _unitOfWorkDelete;
  late UnitOfWorkFind _unitOfWorkFind;
  late UnitOfWorkExecutor _unitOfWorkExecutor;
  late RelationOperation _relationOperation;

  IsolationLevelEnum transactionIsolation = IsolationLevelEnum.REPEATABLE_READ;
  late List<Operation> _operations;
  late List<String> _opResultIdStrings;

  UnitOfWork() {
    _operations = [];
    _opResultIdStrings = [];
    OpResultIdGenerator opResultIdGenerator =
        OpResultIdGenerator(_opResultIdStrings);
    _unitOfWorkCreate = UnitOfWorkCreate(_operations, opResultIdGenerator);
    _unitOfWorkUpdate = UnitOfWorkUpdate(_operations, opResultIdGenerator);
    _unitOfWorkUpsert = UnitOfWorkUpsert(_operations, opResultIdGenerator);
    _unitOfWorkDelete = UnitOfWorkDelete(_operations, opResultIdGenerator);
    _unitOfWorkFind = UnitOfWorkFind(_operations, opResultIdGenerator);
    _relationOperation = RelationOperation(_operations, opResultIdGenerator);
    _unitOfWorkExecutor = UnitOfWorkExecutor(this);
  }

  List<Operation> get operations => _operations;

  List<String> get opResultIdStrings => _opResultIdStrings;

  Future<UnitOfWorkResult> execute() {
    return _unitOfWorkExecutor.execute();
  }

  OpResult create<T>(T instance, [String? tableName]) {
    return _unitOfWorkCreate.create(instance, tableName);
  }

  OpResult bulkCreate<T>(List<T> instances, [String? tableName]) {
    return _unitOfWorkCreate.bulkCreate(instances, tableName);
  }

  OpResult update<T>(T changes,
      {required dynamic identifier,
      Map<String, BackendlessExpression>? expression}) {
    if (identifier == null) {
      throw ArgumentError(ExceptionMessage.emptyNullIdentifier);
    }

    if (expression?.isNotEmpty ?? false) {
      Map? mapChanges = reflector.serialize(changes);
      mapChanges!.addAll(expression!);

      return _unitOfWorkUpdate.update(mapChanges, identifier);
    }

    return _unitOfWorkUpdate.update(changes, identifier!);
  }

  OpResult bulkUpdate(Map changes, dynamic identifier,
      {String? tableName, Map<String, BackendlessExpression>? expression}) {
    if (identifier == null) {
      throw ArgumentError(ExceptionMessage.emptyNullIdentifier);
    }

    if (expression?.isNotEmpty ?? false) {
      Map? mapChanges = reflector.serialize(changes);
      mapChanges!.addAll(expression!);

      return _unitOfWorkUpdate.bulkUpdate(mapChanges, identifier, tableName);
    }

    return _unitOfWorkUpdate.bulkUpdate(changes, identifier, tableName);
  }

  OpResult upsert<T>(T instance, [String? tableName]) {
    return _unitOfWorkUpsert.upsert(instance, tableName);
  }

  OpResult bulkUpsert<T>(List<T> instances, [String? tableName]) {
    return _unitOfWorkUpsert.bulkUpsert(instances, tableName);
  }

  OpResult delete<T>(T value, [String? tableName]) {
    return _unitOfWorkDelete.delete(value, tableName);
  }

  OpResult bulkDelete<T>(T value, [String? tableName]) {
    return _unitOfWorkDelete.bulkDelete(value, tableName);
  }

  OpResult find(String tableName, DataQueryBuilder queryBuilder) {
    return _unitOfWorkFind.find(tableName, queryBuilder);
  }

  OpResult? addToRelation(dynamic parent, String columnName, dynamic children,
      [String? parentTable]) {
    return _relationOperation.addOperation(
        OperationType.ADD_RELATION, parent, columnName, children, parentTable);
  }

  OpResult? setRelation(dynamic parent, String columnName, dynamic children,
      [String? parentTable]) {
    return _relationOperation.addOperation(
        OperationType.SET_RELATION, parent, columnName, children, parentTable);
  }

  OpResult? deleteRelation(dynamic parent, String columnName, dynamic children,
      [String? parentTable]) {
    return _relationOperation.addOperation(OperationType.DELETE_RELATION,
        parent, columnName, children, parentTable);
  }

  Map toJson() => {
        "isolationLevelEnum": describeEnum(transactionIsolation),
        "operations": operations,
      };
}
