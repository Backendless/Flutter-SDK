part of backendless_sdk;

class BackendlessCustomService {
  factory BackendlessCustomService() => _instance;

  static final BackendlessCustomService _instance =
      new BackendlessCustomService._internal();

  BackendlessCustomService._internal();

  Future<dynamic> invoke(String serviceName, String method, dynamic arguments,
          {InvokeOptions? options}) =>
      Invoker.invoke("services/$serviceName/$method", arguments,
          options: options);
}
