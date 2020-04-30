part of backendless_sdk;

class UnitOfWorkResult {
  bool success;
  TransactionOperationError error;
  Map<String, OperationResult> results;

  UnitOfWorkResult(this.success, this.error);

  UnitOfWorkResult.fromJson(Map json) {
    this.success = json['success'];
    this.error = json['error'] != null ? TransactionOperationError.fromJson(json['error']) : null;
    if (json['results'] == null) return;

    results = Map();
    (json['results'] as Map).forEach((key, value) {
      results[key] = OperationResult.fromJson(value);
    });
  }

  @override
   String toString()
  {
    String error = this.error != null ? this.error.toString() : "error=null";
    return "UnitOfWorkResult{success=$success, $error, results=$results}";
  }


}