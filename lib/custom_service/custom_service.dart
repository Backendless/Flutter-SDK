part of backendless_sdk;

class CustomService {
  factory CustomService() => _instance;

  static final CustomService _instance = CustomService._internal();

  CustomService._internal();

  Future<dynamic> invoke(String serviceName, String method, dynamic arguments,
          {InvokeOptions? options}) =>
      Invoker._invokeCustomService("services/$serviceName/$method", arguments,
          options: options);
}
