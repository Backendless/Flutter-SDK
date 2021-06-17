part of backendless_sdk;

class BackendlessRT {
  static const MethodChannel _channel = const MethodChannel('backendless/rt');
  final Map<int, Result> _connectCallbacks = <int, Result>{};
  final Map<int, Result> _reconnectCallbacks = <int, Result>{};
  final Map<int, Result> _connectErrorCallbacks = <int, Result>{};
  final Map<int, Result> _disconnectCallbacks = <int, Result>{};

  factory BackendlessRT() => _instance;
  static final BackendlessRT _instance = new BackendlessRT._internal();

  BackendlessRT._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method.contains("EventResponse")) {
        Map<dynamic, dynamic> arguments = call.arguments;
        int handle = arguments["handle"];
        var result = arguments["result"];

        switch (call.method) {
          case ("Backendless.RT.Connect.EventResponse"):
            _connectCallbacks[handle]?.handle();
            break;
          case ("Backendless.RT.ReconnectAttempt.EventResponse"):
            _reconnectCallbacks[handle]?.handle(result);
            break;
          case ("Backendless.RT.ConnectError.EventResponse"):
            _connectErrorCallbacks[handle]?.handle(result);
            break;
          case ("Backendless.RT.Disconnect.EventResponse"):
            _disconnectCallbacks[handle]?.handle(result);
            break;
        }
      }
    });
  }

  Future<void> connect() => _channel.invokeMethod("Backendless.RT.connect");

  Future<void> disconnect() =>
      _channel.invokeMethod("Backendless.RT.disconnect");

  Future<void> addConnectListener(void callback()) =>
      _addListener("addConnectListener", callback, _connectCallbacks);

  Future<void> addReconnectAttemptListener(
          void callback(ReconnectAttempt result)) =>
      _addListener(
          "addReconnectAttemptListener", callback, _reconnectCallbacks);

  Future<void> addConnectErrorListener(void callback(BackendlessFault fault)) =>
      _addListener("addConnectErrorListener", callback, _connectErrorCallbacks);

  Future<void> addDisconnectListener(void callback(String result)) =>
      _addListener("addDisconnectListener", callback, _disconnectCallbacks);

  Future<void> _addListener(
          String methodName, Function callback, Map<int, Result> callbacks) =>
      _channel
          .invokeMethod("Backendless.RT.$methodName")
          .then((handle) => callbacks[handle] = new Result(callback));

  void removeListener(Function callback) {
    _removeListenerFrom(callback, _connectCallbacks, "connect");
    _removeListenerFrom(callback, _reconnectCallbacks, "reconnect");
    _removeListenerFrom(callback, _connectErrorCallbacks, "connectError");
    _removeListenerFrom(callback, _disconnectCallbacks, "disconnect");
  }

  void _removeListenerFrom(
      Function callback, Map<int, Result> callbacks, String callbacksName) {
    List<int> toRemove = [];
    callbacks.forEach((handle, result) {
      if (result.handle == callback) {
        toRemove.add(handle);
      }
    });

    toRemove.forEach((handle) {
      _channel.invokeMethod("Backendless.RT.removeListener",
          <String, dynamic>{"callbacksName": callbacksName, "handle": handle});
      callbacks.remove(handle);
    });
  }

  Future<void> removeConnectionListeners() {
    _connectCallbacks.clear();
    return _channel.invokeMethod("Backendless.RT.removeConnectionListeners");
  }
}

class BackendlessFault {}

class ReconnectAttempt {
  final int timeout;
  final int attempt;

  ReconnectAttempt(this.timeout, this.attempt);

  ReconnectAttempt.fromJson(Map json)
      : timeout = json['timeout'],
        attempt = json['attempt'];

  Map toJson() => {
        'timeout': timeout,
        'attempt': attempt,
      };

  @override
  String toString() => "ReconnectAttempt{timeout=$timeout, attempt=$attempt}";
}

class Result {
  Function handle;

  Result(this.handle);
}
