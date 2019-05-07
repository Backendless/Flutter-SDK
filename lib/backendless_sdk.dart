import 'dart:async';

import 'package:flutter/services.dart';

class BackendlessSdk {
  static const MethodChannel _channel =
      const MethodChannel('backendless_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
