part of backendless_sdk;

class UnitOfWork {
  static const String REFERENCE_MARKER = "___ref";
  static const String OP_RESULT_ID = "opResultId";
  static const String RESULT_INDEX = "resultIndex";
  static const String PROP_NAME = "propName";

  UnitOfWorkCreate _unitOfWorkCreate;
  UnitOfWorkUpdate _unitOfWorkUpdate;
  UnitOfWorkDelete _unitOfWorkDelete;
  UnitOfWorkFind _unitOfWorkFind;
  UnitOfWorkExecutor _unitOfWorkExecutor;
  RelationOperation _relationOperation;

  IsolationLevelEnum transactionIsolation = IsolationLevelEnum.REPEATABLE_READ;
  List<Operation> _operations;
  List<String> _opResultIdStrings;

  UnitOfWork() {
    _operations = new List();
    _opResultIdStrings = new List();
    OpResultIdGenerator opResultIdGenerator =
        new OpResultIdGenerator(_opResultIdStrings);
    _unitOfWorkCreate = new UnitOfWorkCreate(_operations, opResultIdGenerator);
    _unitOfWorkUpdate = new UnitOfWorkUpdate(_operations, opResultIdGenerator);
    _unitOfWorkDelete = new UnitOfWorkDelete(_operations, opResultIdGenerator);
    _unitOfWorkFind = new UnitOfWorkFind(_operations, opResultIdGenerator);
    _relationOperation =
        new RelationOperation(_operations, opResultIdGenerator);
    _unitOfWorkExecutor = new UnitOfWorkExecutor(this);
  }

  List<Operation> get operations => _operations;

  List<String> get opResultIdStrings => _opResultIdStrings;

  Future<UnitOfWorkResult> execute() {
    return _unitOfWorkExecutor.execute();
  }

  OpResult create<T>(T instance, [String tableName]) {
    return _unitOfWorkCreate.create(instance, tableName);
  }

  OpResult bulkCreate<T>(List<T> instances, [String tableName]) {
    return _unitOfWorkCreate.bulkCreate(instances, tableName);
  }

  OpResult update<T>(T changes, [dynamic identifier]) {
    return _unitOfWorkUpdate.update(changes, identifier);
  }

  OpResult bulkUpdate(Map changes, dynamic identifier, [String tableName]) {
    return _unitOfWorkUpdate.bulkUpdate(changes, identifier, tableName);
  }

  OpResult delete<T>(T value, [String tableName]) {
    return _unitOfWorkDelete.delete(value, tableName);
  }

  OpResult bulkDelete<T>(T value, [String tableName]) {
    return _unitOfWorkDelete.bulkDelete(value, tableName);
  }

  OpResult find(String tableName, DataQueryBuilder queryBuilder) {
    return _unitOfWorkFind.find(tableName, queryBuilder);
  }

  OpResult addToRelation(dynamic parent, String columnName, dynamic children,
      [String parentTable]) {
    return _relationOperation.addOperation(
        OperationType.ADD_RELATION, parent, columnName, children, parentTable);
  }

  OpResult setRelation(dynamic parent, String columnName, dynamic children,
      [String parentTable]) {
    return _relationOperation.addOperation(
        OperationType.SET_RELATION, parent, columnName, children, parentTable);
  }

  OpResult deleteRelation(dynamic parent, String columnName, dynamic children,
      [String parentTable]) {
    return _relationOperation.addOperation(OperationType.DELETE_RELATION,
        parent, columnName, children, parentTable);
  }

  Map toJson() => {
        "isolationLevelEnum": describeEnum(transactionIsolation),
        "operations": operations,
      };
}
