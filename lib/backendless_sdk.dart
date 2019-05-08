import 'dart:io';

import 'package:flutter/services.dart';
import 'package:backendless_sdk/src/modules/modules.dart';

class Backendless {
  static final Data = new BackendlessData();
  static final Cache = new BackendlessCache();
  static final Commerce = new BackendlessCommerce();
  static final Counters = new BackendlessCounters();
  static final CustomService = new BackendlessCustomService();
  static final Events = new BackendlessEvents();
  static final Files = new BackendlessFiles();
  static final Geo = new BackendlessGeo();
  static final Logging = new BackendlessLogging();
  static final Messaging = new BackendlessMessaging();
  static final RT = new BackendlessRT();
  static final UserService = new BackendlessUserService();

  static const MethodChannel _channel = const MethodChannel('backendless');

  static Future<void> initApp(
      String applicationId, String androidApiKey, String iosApiKey) {
    String apiKey;
    if (Platform.isAndroid)
      apiKey = androidApiKey;
    else if (Platform.isIOS) apiKey = iosApiKey;
    return _channel.invokeMethod('Backendless.initApp',
        <String, dynamic>{'applicationId': applicationId, 'apiKey': apiKey});
  }

  static Future<String> getApiKey() =>
      _channel.invokeMethod("Backendless.getApiKey");

  static Future<String> getApplicationId() =>
      _channel.invokeMethod("Backendless.getApplicationId");

  static Future<int> getNotificationIdGeneratorInitValue() =>
      _channel.invokeMethod("Backendless.getNotificationIdGeneratorInitValue");

  static Future<String> getPushTemplatesAsJson() =>
      _channel.invokeMethod("Backendless.getPushTemplatesAsJson");

  static Future<String> getUrl() => _channel.invokeMethod("Backendless.getUrl");

  static Future<bool> isInitialized() =>
      _channel.invokeMethod("Backendless.isInitialized");

  static Future<void> saveNotificationIdGeneratorState(int value) =>
      _channel.invokeMethod("Backendless.saveNotificationIdGeneratorState",
          <String, dynamic>{"value": value});

  static Future<void> savePushTemplates(String pushTemplatesAsJson) =>
      _channel.invokeMethod("Backendless.savePushTemplates",
          <String, dynamic>{"pushTemplatesAsJson": pushTemplatesAsJson});

  static Future<void> setUIState(String state) => _channel.invokeMethod(
      "Backendless.setUIState", <String, dynamic>{"state": state});

  static Future<void> setUrl(String url) => _channel
      .invokeMethod("Backendless.setUrl", <String, dynamic>{"url": url});
}
