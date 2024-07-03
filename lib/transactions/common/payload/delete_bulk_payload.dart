part of '../../../backendless_sdk.dart';

class DeleteBulkPayload extends Selector {
  DeleteBulkPayload(super.conditional, super.unconditional);

  DeleteBulkPayload.fromJson(Map json)
      : super(json['conditional'], json['unconditional']);

  Map toJson() => {
        "conditional": conditional,
        "unconditional": unconditional,
      };
}
