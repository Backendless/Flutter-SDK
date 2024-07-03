part of '../../../backendless_sdk.dart';

class UpdateBulkPayload<T> extends Selector {
  Map changes;
  T? query;

  UpdateBulkPayload(super.conditional, super.unconditional, this.changes);

  UpdateBulkPayload.fromJson(Map json)
      : changes = json['changes'],
        super(json['conditional'], json['unconditional']);

  Map toJson() => {
        "conditional": conditional,
        "unconditional": unconditional,
        "changes": changes,
      };
}
