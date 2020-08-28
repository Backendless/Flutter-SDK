@JS()

library backendless_custom_service_web;

import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../js_util.dart';

class CustomServiceCallHandler {
  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {
      case "Backendless.CustomService.invoke":
        return promiseToFuture(invoke(
            call.arguments['serviceName'],
            call.arguments['method'],
            convertToJs(call.arguments['arguments'])));
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "Backendless plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }
}

@JS('Backendless.CustomServices.invoke')
external dynamic invoke(
    String serviceName, String methodName, dynamic parameters);
