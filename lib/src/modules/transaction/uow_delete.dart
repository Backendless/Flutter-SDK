part of backendless_sdk;

class UnitOfWorkDelete {
  final List<Operation> operations;
  final OpResultIdGenerator opResultIdGenerator;

  UnitOfWorkDelete( this.operations, this.opResultIdGenerator );

  OpResult delete(dynamic value, [String tableName]) {
    if (value is Map)
      return _deleteMapInstance(tableName, value);
    if (value is String)
      return _deleteById(tableName, value);
    if (value is OpResult)
      return _deleteOpResult(value);
    if (value is OpResultValueReference)
      return _deleteValueRef(value);
    if (reflector.canReflect(value))
      return _deleteClassInstance(value);
    throw ArgumentError("The value should be either Custom class object, Map, Id, OpResult or OpResultValueReference");
  }
  
  OpResult _deleteClassInstance<E> ( E instance )
  {
    Map<String, Object> entityMap = reflector.serialize(instance);
    String tableName = reflector.getServerName(E);

    return _deleteMapInstance( tableName, entityMap );
  }

  
  OpResult _deleteMapInstance( String tableName, Map<String, Object> objectMap )
  {
    String objectId = objectMap['objectId'];
    return _deleteById( tableName, objectId );
  }

  
  OpResult _deleteById( String tableName, String objectId )
  {
    String operationResultId = opResultIdGenerator.generateOpResultId( OperationType.DELETE, tableName );
    OperationDelete operationDelete = new OperationDelete( OperationType.DELETE, tableName, operationResultId, objectId );

    operations.add( operationDelete );

    return TransactionHelper.makeOpResult( tableName, operationResultId, OperationType.DELETE );
  }

  
  OpResult _deleteOpResult( OpResult result )
  {
    if( !OperationTypeExt.supportEntityDescriptionResultType.contains( result.operationType ) )
      throw new ArgumentError( "This operation result not supported in this operation" );

    String operationResultId = opResultIdGenerator.generateOpResultId( OperationType.DELETE, result.tableName );
    OperationDelete operationDelete = new OperationDelete( OperationType.DELETE, result.tableName, operationResultId,
                                                           result.resolveTo( propName: "objectId" ).makeReference() );

    operations.add( operationDelete );

    return TransactionHelper.makeOpResult( result.tableName, operationResultId, OperationType.DELETE );
  }

  
  OpResult _deleteValueRef( OpResultValueReference resultIndex )
  {
    if( resultIndex.resultIndex== null || resultIndex.propName != null )
      throw new ArgumentError( "This operation result in this operation must resolved only to resultIndex" );

    Map<String, Object> referenceToObjectId = TransactionHelper.convertCreateBulkOrFindResultIndexToObjectId( resultIndex );

    String operationResultId = opResultIdGenerator.generateOpResultId( OperationType.DELETE, resultIndex.opResult.tableName );
    OperationDelete operationDelete = new OperationDelete( OperationType.DELETE, resultIndex.opResult.tableName,
                                                           operationResultId, referenceToObjectId );

    operations.add( operationDelete );

    return TransactionHelper.makeOpResult( resultIndex.opResult.tableName, operationResultId, OperationType.DELETE );
  }

  
  OpResult bulkDeleteClassInstances<E> ( List<E> instances )
  {
    List serializedEntities = instances.map((e) => reflector.serialize(e)).toList();
    String tableName = reflector.getServerName(E);


    return bulkDeleteMapInstances( tableName, serializedEntities );
  }

  
  
  OpResult bulkDeleteMapInstances( String tableName, List<Map<String, Object>> arrayOfObjects )
  {
    List<Object> objectIds = TransactionHelper.convertMapsToObjectIds( arrayOfObjects );

    return _bulkDelete( tableName, null, objectIds );
  }

  OpResult bulkDeleteByIds( String tableName, List<String> objectIdValues )
  {
    return _bulkDelete( tableName, null, objectIdValues );
  }

  
  OpResult bulkDeleteWithQuery( String tableName, String whereClause )
  {
    return _bulkDelete( tableName, whereClause, null );
  }

  
  OpResult bulkDeleteOpResult( OpResult result )
  {
    if( ! ( OperationTypeExt.supportCollectionEntityDescriptionType.contains( result.operationType )
            || OperationTypeExt.supportListIdsResultType.contains( result.operationType ) ) )
      throw new ArgumentError( "This operation result not supported in this operation" );

    return _bulkDelete( result.tableName, null, result.makeReference() );
  }

  OpResult _bulkDelete( String tableName, String whereClause, Object unconditional )
  {
    String operationResultId = opResultIdGenerator.generateOpResultId( OperationType.DELETE_BULK, tableName );
    DeleteBulkPayload deleteBulkPayload = new DeleteBulkPayload( whereClause, unconditional );
    OperationDeleteBulk operationDeleteBulk = new OperationDeleteBulk( OperationType.DELETE_BULK, tableName,
                                                                       operationResultId, deleteBulkPayload );

    operations.add( operationDeleteBulk );

    return TransactionHelper.makeOpResult( tableName, operationResultId, OperationType.DELETE_BULK );
  }
}