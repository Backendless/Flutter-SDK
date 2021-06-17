@JS()

library backendless_base_web;

import 'package:flutter/services.dart';
import 'package:js/js.dart';

class BackendlessCallHandler {
  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {
      case "Backendless.initApp":
        if ((call.arguments as Map).containsKey("customDomain")) {
          return Future<void>(() {
            initAppWithCustomDomain(call.arguments['customDomain']);
          });
        } else {
          return Future<void>(() {
            initApp(call.arguments['applicationId'], call.arguments['apiKey']);
          });
        }
      case "Backendless.setUrl":
        return Future<void>(() {
          BackendlessJs.serverURL = call.arguments['url'];
        });
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "Backendless plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }
}

@JS('Backendless')
class BackendlessJs {
  external static set serverURL(String url);
}

@JS('Backendless.initApp')
external dynamic initApp(String appId, String jsKey);

@JS('Backendless.initApp')
external dynamic initAppWithCustomDomain(String customDomain);
