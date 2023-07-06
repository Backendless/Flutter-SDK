// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'backendless_sdk.dart';

/// A web implementation of the BackendlessSdkPlatform of the BackendlessSdk plugin.
class BackendlessSdkWeb {
  /// Constructs a BackendlessSdkWeb
  BackendlessSdkWeb();

  static void registerWith(Registrar registrar) {
    // ignore: unused_local_variable
    final MethodChannel backendlessChannel = MethodChannel("backendless",
        const StandardMethodCodec(BackendlessMessageCodec()), registrar);
    /*backendlessChannel
        .setMethodCallHandler(BackendlessCallHandler().handleMethodCall);*/
  }

  /// Returns a [String] containing the version of the platform.
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }
}
