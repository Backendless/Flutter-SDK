part of backendless_sdk;

class TransactionOperationError {
  Operation operation;
  String message;

  TransactionOperationError(this.operation, this.message);

  @override
  String toString() {
    return "TransactionOperationError{operation=" +
        operation.toString() +
        ", message=" +
        message +
        "}";
  }

  TransactionOperationError.fromJson(Map json) {
    message = json['message'];

    if (json['operation'] == null) return;

    switch (json['operation']['operationType']) {
      case ('CREATE'):
        operation = OperationCreate.fromJson(json['operation']);
        break;
      case ('CREATE_BULK'):
        operation = OperationCreateBulk.fromJson(json['operation']);
        break;
      case ('UPDATE'):
        operation = OperationUpdate.fromJson(json['operation']);
        break;
      case ('UPDATE_BULK'):
        operation = OperationUpdateBulk.fromJson(json['operation']);
        break;
      case ('DELETE'):
        operation = OperationDelete.fromJson(json['operation']);
        break;
      case ('DELETE_BULK'):
        operation = OperationDeleteBulk.fromJson(json['operation']);
        break;
      case ('FIND'):
        operation = OperationFind.fromJson(json['operation']);
        break;
      case ('ADD_RELATION'):
        operation = OperationAddRelation.fromJson(json['operation']);
        break;
      case ('SET_RELATION'):
        operation = OperationSetRelation.fromJson(json['operation']);
        break;
      case ('DELETE_RELATION'):
        operation = OperationDeleteRelation.fromJson(json['operation']);
        break;
    }
  }
}
