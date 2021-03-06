part of backendless_sdk;

class BackendlessData {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/data', StandardMethodCodec(BackendlessMessageCodec()));
  static final Map<int, DataSubscription> _subscriptions =
      <int, DataSubscription>{};

  factory BackendlessData() => _instance;
  static final BackendlessData _instance = new BackendlessData._internal();

  BackendlessData._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method.contains("EventResponse")) {
        Map<dynamic, dynamic> arguments = call.arguments;

        switch (call.method) {
          case ("Backendless.Data.RT.EventResponse"):
            int handle = arguments["handle"];
            var response = arguments["response"];
            _subscriptions[handle]?.handleResponse(response);
            break;
          case ("Backendless.Data.RT.EventFault"):
            int handle = arguments["handle"];
            String fault = call.arguments["fault"];
            _subscriptions[handle]?.handleFault(fault);
            break;
        }
      }
    });
  }

  IDataStore<Map> of(String tableName) => new MapDrivenDataStore(tableName);

  IDataStore<T> withClass<T>() => new ClassDrivenDataStore<T>();

  Future<Map?> callStoredProcedure(
          String procedureName, Map<String, Object> arguments) =>
      _channel.invokeMethod(
          "Backendless.Data.callStoredProcedure", <String, dynamic>{
        'procedureName': procedureName,
        'arguments': arguments
      });

  Future<List<ObjectProperty>> describe(String tableName) async =>
      (await _channel.invokeMethod("Backendless.Data.describe",
              <String, dynamic>{'tableName': tableName}))
          .cast<ObjectProperty>();

  Future<Map<String, Object>> getView(
          String viewName, DataQueryBuilder queryBuilder) async =>
      (await _channel.invokeMethod(
              "Backendless.Data.getView", <String, dynamic>{
        'viewName': viewName,
        'queryBuilder': queryBuilder
      }))
          .cast<String, Object>();

  void mapTableToClass(String tableName, Type type) =>
      Types.addClientClassMapping(tableName, type);
}
