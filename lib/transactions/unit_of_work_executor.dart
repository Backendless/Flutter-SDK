part of backendless_sdk;

class UnitOfWorkExecutor {
  final UnitOfWork unitOfWork;

  UnitOfWorkExecutor(this.unitOfWork);

  Future<UnitOfWorkResult> execute() async {
    if (unitOfWork.operations.isEmpty)
      throw new ArgumentError(
          "List of operations in unitOfWork can not be null or empty");

    final response = await Invoker.post("transaction/unit-of-work", unitOfWork);
    return UnitOfWorkResult.fromJson(response);
  }
}
