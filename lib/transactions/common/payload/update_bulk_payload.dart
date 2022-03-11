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
