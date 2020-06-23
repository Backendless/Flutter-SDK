@JS()

library backendless_base_web;

import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

class BackendlessCallHandler {

  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {
      case "Backendless.initApp":
        return promiseToFuture(
          initApp(call.arguments['applicationId'], call.arguments['apiKey']));
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "The url_launcher plugin for web doesn't implement "
              "the method '${call.method}'");
    }

  }
}

@JS('Backendless.initApp')
external dynamic initApp(String appId, String sKey);