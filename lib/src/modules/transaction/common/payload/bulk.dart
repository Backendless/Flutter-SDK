part of backendless_sdk;

class UpdateBulkPayload<T> extends Selector {
  Map changes;
  T? query;

  UpdateBulkPayload(String? conditional, Object? unconditional, this.changes)
      : super(conditional, unconditional);

  UpdateBulkPayload.fromJson(Map json)
      : changes = json['changes'],
        super(json['conditional'], json['unconditional']);

  Map toJson() => {
        "conditional": conditional,
        "unconditional": unconditional,
        "changes": changes,
      };
}

class DeleteBulkPayload extends Selector {
  DeleteBulkPayload(String? conditional, Object? unconditional)
      : super(conditional, unconditional);

  DeleteBulkPayload.fromJson(Map json)
      : super(json['conditional'], json['unconditional']);

  Map toJson() => {
        "conditional": conditional,
        "unconditional": unconditional,
      };
}
