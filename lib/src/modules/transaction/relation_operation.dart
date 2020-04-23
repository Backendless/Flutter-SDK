part of backendless_sdk;

class RelationOperation {
  final List<Operation> operations;
  final OpResultIdGenerator opResultIdGenerator;

  RelationOperation(this.operations, this.opResultIdGenerator);

  OpResult addOperation(OperationType operationType, dynamic parent, String columnName, 
    dynamic children, [String parentTable]) {

    dynamic _parent;
    String _table;
    dynamic _children;
    String _whereClause;

    if (parent is Map) {
      _parent = parent['objectId'];
      _table = parentTable;
    } else if (parent is String) {
      _parent = parent;
      _table = parentTable;
    } else if (parent is OpResult) {
      _parent = parent.resolveTo(propName: 'objectId').makeReference();
      _table = parent.tableName;
    } else if (parent is OpResultValueReference) {
      _parent = TransactionHelper.convertCreateBulkOrFindResultIndexToObjectId( parent );
      _table = parent.opResult.tableName;
    } else if (reflector.canReflect(parent)) {
      _parent = parent.objectId;
      _table = reflector.getServerName(parent.runtimeType);
    } else {
      throw ArgumentError("The value should be either Custom class object, Map, Id, OpResult or OpResultValueReference");
    }

    if (children is List) {
        _whereClause = null;
      if (children[0] is String) {
        _children = children;
      } else if (children[0] is Map) {
        _children = children.map((e) => e['objectId']).toList();
      } else if (reflector.canReflect(children[0])) {
        _children = children.map((e) => e.objectId).toList();
      } else {
        throw ArgumentError("The children argument should be the list of IDs, Maps or Custom class objects");
      }
    } else if (children is OpResult) {
      _children = children.makeReference();
        _whereClause = null;
    } else if (children is String) {
      _children = null;
      _whereClause = children;
    } else {
      throw ArgumentError("The children argument should be either List, OpResult or whereClause");
    }

    _addOperation(operationType, _table, _parent, columnName, _whereClause, _children);

  }


  OpResult _addOperation( OperationType operationType, String parentTable, Object parentObject,
                                 String columnName, String whereClauseForChildren, Object children ) {
    
    String operationResultId = opResultIdGenerator.generateOpResultId( operationType, parentTable );

    Relation relation = new Relation();
    relation.parentObject = parentObject ;
    relation.relationColumn = columnName ;
    relation.conditional = whereClauseForChildren ;
    relation.unconditional = children ;
    switch( operationType )
    {
      case OperationType.ADD_RELATION:
        operations.add( new OperationAddRelation( operationType, parentTable, operationResultId, relation ) );
        break;
      case OperationType.SET_RELATION:
        operations.add( new OperationSetRelation( operationType, parentTable, operationResultId, relation ) );
        break;
      case OperationType.DELETE_RELATION:
        operations.add( new OperationDeleteRelation( operationType, parentTable, operationResultId, relation ) );
        break;
      default:
        return null;
    }

    return TransactionHelper.makeOpResult( parentTable, operationResultId, operationType );                              
  }

                                 
}