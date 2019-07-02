part of backendless_sdk;

class BackendlessEvents {
  static const MethodChannel _channel =
      const MethodChannel('backendless/events');

  factory BackendlessEvents() => _instance;
  static final BackendlessEvents _instance = new BackendlessEvents._internal();
  BackendlessEvents._internal();

  /// This method does not support passing custom classes as arguments for now
  Future<Map> dispatch(String eventName, Map eventArgs) =>
      _channel.invokeMethod("Backendless.Events.dispatch",
          <String, dynamic>{"eventName": eventName, "eventArgs": eventArgs});
}
