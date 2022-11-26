part of backendless_sdk;

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
