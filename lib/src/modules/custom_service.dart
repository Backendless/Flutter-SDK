part of backendless_sdk;

class BackendlessCustomService {
  static const MethodChannel _channel =
      const MethodChannel('backendless/custom_service');

  factory BackendlessCustomService() => _instance;
  static final BackendlessCustomService _instance =
      new BackendlessCustomService._internal();
  BackendlessCustomService._internal();

  /// This method does not support passing custom classes as arguments for now
  Future<dynamic> invoke(
          String serviceName, String method, List<Object> arguments) =>
      _channel.invokeMethod(
          "Backendless.CustomService.invoke", <String, dynamic>{
        "serviceName": serviceName,
        "method": method,
        "arguments": arguments
      });
}