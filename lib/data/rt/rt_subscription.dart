part of backendless_sdk;

class RTSubscription {
  String? subscriptionId;
  Map<String, dynamic>? data;
  Map<String, dynamic>? options;
  String? type;
  bool ready = false;
  void Function(dynamic response)? callback;

  void subscribe() {
    if (data != null) RTClient.instance.subscribe(this.data!, this);
  }
}
