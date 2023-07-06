part of backendless_sdk;

class RTSubscription<T> {
  String? subscriptionId;
  Map<String, dynamic>? data;
  Map<String, dynamic>? options;
  String? type;
  bool ready = false;
  void Function(T? response)? callback;

  void subscribe() {
    if (data != null) RTListener.clientInstance!.subscribe<T>(data!, this);
  }

  void stop() {
    RTListener.unsubscribe(subscriptionId!);
  }
}
