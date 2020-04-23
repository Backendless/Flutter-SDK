part of backendless_sdk;

class TransactionOperationError {
  Operation operation;
  String message;

TransactionOperationError(this.operation, this.message);

@override
   String toString()
  {
    return "TransactionOperationError{operation=" + operation.toString() + ", message=" + message + "}";
  }
}