part of backendless_sdk;

class UnitOfWorkFind {
  final List<Operation> operations;
  final OpResultIdGenerator opResultIdGenerator;

  UnitOfWorkFind(this.operations, this.opResultIdGenerator);

  OpResult find(String tableName, DataQueryBuilder queryBuilder) {
    // BackendlessDataQuery query = queryBuilder.build();

    String operationResultId =
        opResultIdGenerator.generateOpResultId(OperationType.FIND, tableName);

    OperationFind operationFind = OperationFind(
        OperationType.FIND, tableName, operationResultId, queryBuilder);

    operations.add(operationFind);

    return TransactionHelper.makeOpResult(
        tableName, operationResultId, OperationType.FIND);
  }
}
