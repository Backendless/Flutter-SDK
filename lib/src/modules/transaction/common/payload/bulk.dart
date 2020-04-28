part of backendless_sdk;

class UpdateBulkPayload<T> extends Selector {
  Map changes;
  T query;

  UpdateBulkPayload(String conditional, Object unconditional, this.changes) : super(conditional, unconditional);
}

class DeleteBulkPayload extends Selector {
  
  DeleteBulkPayload( String conditional, Object unconditional ) : super(conditional, unconditional);
}