part of backendless_sdk;

class UnitOfWorkResult {
  bool success;
  TransactionOperationError error;
  Map<String, OperationResult> results;

  UnitOfWorkResult(this.success, this.error);

  @override
   String toString()
  {
    String error = this.error != null ? this.error.toString() : "error=null";
    return "UnitOfWorkResult{success=$success, $error, results=$results}";
  }


}