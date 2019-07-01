part of backendless_sdk;

class BackendlessCommerce {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/commerce', StandardMethodCodec(BackendlessMessageCodec()));

  factory BackendlessCommerce() => _instance;
  static final BackendlessCommerce _instance =
      new BackendlessCommerce._internal();
  BackendlessCommerce._internal();

  Future<void> cancelPlaySubscription(
          String packageName, String subscriptionId, String token) =>
      _channel.invokeMethod(
          "Backendless.Commerce.cancelPlaySubscription", <String, dynamic>{
        "packageName": packageName,
        "subscriptionId": subscriptionId,
        "token": token
      });

  Future<GooglePlaySubscriptionStatus> getPlaySubscriptionsStatus(
          String packageName, String subscriptionId, String token) =>
      _channel.invokeMethod(
          "Backendless.Commerce.getPlaySubscriptionsStatus", <String, dynamic>{
        "packageName": packageName,
        "subscriptionId": subscriptionId,
        "token": token
      });

  Future<GooglePlayPurchaseStatus> validatePlayPurchase(
          String packageName, String productId, String token) =>
      _channel.invokeMethod(
          "Backendless.Commerce.validatePlayPurchase", <String, dynamic>{
        "packageName": packageName,
        "productId": productId,
        "token": token
      });
}