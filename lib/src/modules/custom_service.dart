part of backendless_sdk;

class BackendlessCustomService {
  static const MethodChannel _channel =
      const MethodChannel('backendless/custom_service');

  factory BackendlessCustomService() => _instance;
  static final BackendlessCustomService _instance =
      new BackendlessCustomService._internal();
  BackendlessCustomService._internal();

  Future<dynamic> invoke(
          String serviceName, String method, Map arguments) {
    // temp workaround because Android accepts args as List
    dynamic args = (!kIsWeb && Platform.isAndroid) ? arguments.values.toList() : arguments;

    return _channel.invokeMethod(
          "Backendless.CustomService.invoke", <String, dynamic>{
        "serviceName": serviceName,
        "method": method,
        "arguments": args,
      });
  }
}
