part of backendless_sdk;

class UpdateBulkPayload<T> extends Selector {
  Map changes;
  T query;

  UpdateBulkPayload(String conditional, Object unconditional, this.changes) : super(conditional, unconditional);

  String toJson() {
    String properties = (conditional != null) ? 
      '"conditional": "$conditional"' : '"unconditional": ${jsonEncode(unconditional)}';
    return '{$properties, "changes": ${jsonEncode(changes)}}';
  }
}

class DeleteBulkPayload extends Selector {
  
  DeleteBulkPayload( String conditional, Object unconditional ) : super(conditional, unconditional);

  String toJson() {
    return (conditional != null) ? 
      '{"conditional": "$conditional"}' : '{"unconditional": ${jsonEncode(unconditional)}}';
  }
}