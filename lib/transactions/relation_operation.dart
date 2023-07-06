part of backendless_sdk;

class RelationOperation {
  final List<Operation> operations;
  final OpResultIdGenerator opResultIdGenerator;

  RelationOperation(this.operations, this.opResultIdGenerator);

  OpResult? addOperation(OperationType operationType, dynamic parent,
      String? columnName, dynamic children,
      [String? parentTable]) {
    dynamic localParent;
    String localTable;
    dynamic localChildren;
    String? localWhereClause;

    if (parent is Map) {
      localParent = parent['objectId'];
      localTable = parentTable!;
    } else if (parent is String) {
      localParent = parent;
      localTable = parentTable!;
    } else if (parent is OpResult) {
      localParent = parent.resolveTo(propName: 'objectId').makeReference();
      localTable = parent.tableName;
    } else if (parent is OpResultValueReference) {
      localParent =
          TransactionHelper.convertCreateBulkOrFindResultIndexToObjectId(
              parent);
      localTable = parent.opResult.tableName;
    } else if (reflector.canReflect(parent)) {
      localParent = parent.objectId;
      localTable = reflector.getServerName(parent.runtimeType)!;
    } else {
      throw ArgumentError(
          "The value should be either Custom class object, Map, Id, OpResult or OpResultValueReference");
    }

    if (children is List) {
      localWhereClause = null;
      if (children[0] is String) {
        localChildren = children;
      } else if (children[0] is Map) {
        localChildren = children.map((e) => e['objectId']).toList();
      } else if (reflector.canReflect(children[0])) {
        localChildren = children.map((e) => e.objectId).toList();
      } else {
        throw ArgumentError(
            'The children argument should be the list of IDs, Maps or Custom class objects');
      }
    } else if (children is OpResult) {
      localChildren = children.makeReference();
      localWhereClause = null;
    } else if (children is String) {
      localChildren = null;
      localWhereClause = children;
    } else {
      throw ArgumentError(
          'The children argument should be either List, OpResult or whereClause');
    }

    return _addOperation(operationType, localTable, localParent, columnName,
        localWhereClause, localChildren);
  }

  OpResult? _addOperation(
      OperationType operationType,
      String parentTable,
      Object parentObject,
      String? columnName,
      String? whereClauseForChildren,
      Object? children) {
    String operationResultId =
        opResultIdGenerator.generateOpResultId(operationType, parentTable);

    Relation relation = Relation();
    relation.parentObject = parentObject;
    relation.relationColumn = columnName;
    relation.conditional = whereClauseForChildren;
    relation.unconditional = children;
    switch (operationType) {
      case OperationType.ADD_RELATION:
        operations.add(OperationAddRelation(
            operationType, parentTable, operationResultId, relation));
        break;
      case OperationType.SET_RELATION:
        operations.add(OperationSetRelation(
            operationType, parentTable, operationResultId, relation));
        break;
      case OperationType.DELETE_RELATION:
        operations.add(OperationDeleteRelation(
            operationType, parentTable, operationResultId, relation));
        break;
      default:
        return null;
    }

    return TransactionHelper.makeOpResult(
        parentTable, operationResultId, operationType);
  }
}
