part of backendless_sdk;

class UnitOfWorkExecutor {

  final UnitOfWork unitOfWork;

  UnitOfWorkExecutor( this.unitOfWork );

  Future<UnitOfWorkResult> execute()
  {
    if( unitOfWork.operations == null || unitOfWork.operations.isEmpty )
      throw new ArgumentError( "List of operations in unitOfWork can not be null or empty" );

    // return channel.invokeMthod("transactions", unitOfWork);
  }
}