@JS()

library backendless_base_web;

import 'package:flutter/services.dart';
import 'package:js/js.dart';

class BackendlessCallHandler {
  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {
      case "Backendless.initApp":
        return Future<void>(() {
          BackendlessJs.initApp(
              call.arguments['applicationId'], call.arguments['apiKey']);
        });
      case "Backendless.getApiKey":
        return Future(() => BackendlessJs.secretKey);
      case "Backendless.getApplicationId":
        return Future(() => BackendlessJs.applicationId);
      case "Backendless.getUrl":
        return Future(() => BackendlessJs.serverURL);
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
  external static void initApp(String appId, String sKey);

  external static String get secretKey;

  external static String get applicationId;

  external static String get serverURL;

  external static set serverURL(String url);
}
