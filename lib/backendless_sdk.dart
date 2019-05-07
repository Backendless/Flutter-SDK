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


  static const MethodChannel _channel =
      const MethodChannel('backendless');

  static void initApp(final String applicationId, final String apiKey) {
    _channel.invokeMethod('Backendless.initApp', <String, dynamic> {
      'applicationId': applicationId,
      'apiKey': apiKey
    });
  }

  static Future<String> getApiKey() async => _channel.invokeMethod("Backendless.getApiKey");

  static Future<String> getApplicationId() async => _channel.invokeMethod("Backendless.getApplicationId");

  static Future<int> getNotificationIdGeneratorInitValue() async => _channel.invokeMethod("Backendless.getNotificationIdGeneratorInitValue");

  static Future<String> getPushTemplatesAsJson() async => _channel.invokeMethod("Backendless.getPushTemplatesAsJson");

  static Future<String> getUrl() async => _channel.invokeMethod("Backendless.getUrl");

  static Future<bool> isInitialized() async => _channel.invokeMethod("Backendless.isInitialized");

  static Future<void> saveNotificationIdGeneratorState(int value) =>
    _channel.invokeMethod("Backendless.saveNotificationIdGeneratorState", <String, dynamic> {
      "value":value
    });

  static Future<void> savePushTemplates(String pushTemplatesAsJson) async =>
    _channel.invokeMethod("Backendless.savePushTemplates", <String, dynamic> {
      "pushTemplatesAsJson":pushTemplatesAsJson
    });

  static Future<void> setUIState(String state) async =>
    _channel.invokeMethod("Backendless.setUIState", <String, dynamic> {
      "state":state
    });

  static Future<void> setUrl(String url) async =>
    _channel.invokeMethod("Backendless.setUrl", <String, dynamic> {
      "url":url
    });
}