part of '../../../backendless_sdk.dart';

class Selector {
  String? conditional;
  Object? unconditional;

  Selector(this.conditional, this.unconditional);

  @override
  String toString() {
    return "Selector{"
        "conditional='$conditional', unconditional='$unconditional'}";
  }
}
