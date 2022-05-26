part of backendless_sdk;

class RTSubscription<T> {
  String? subscriptionId;
  Map<String, dynamic>? data;
  Map<String, dynamic>? options;
  String? type;
  bool ready = false;
  void Function(T response)? callback;

  void subscribe() {
    if (data != null) RTClient.instance.subscribe(this.data!, this);
  }

  void stop() {
    RTClient.instance.unsubscribe(this.subscriptionId!);
  }
}
