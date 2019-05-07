package com.backendless.backendless_sdk.call_handlers;

import com.backendless.Backendless;
import com.backendless.commerce.GooglePlayPurchaseStatus;
import com.backendless.commerce.GooglePlaySubscriptionStatus;
import com.backendless.backendless_sdk.utils.FlutterCallback;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class CommerceCallHandler implements MethodChannel.MethodCallHandler {

    public CommerceCallHandler() {
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.Commerce.cancelPlaySubscription":
                cancelPlaySubscription(call);
                break;
            case "Backendless.Commerce.getPlaySubscriptionsStatus":
                getPlaySubscriptionsStatus(call, result);
                break;
            case "Backendless.Commerce.validatePlayPurchase":
                validatePlayPurchase(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void cancelPlaySubscription(MethodCall call) {
        String packageName = call.argument("packageName");
        String subscriptionId = call.argument("subscriptionId");
        String token = call.argument("token");

        Backendless.Commerce.cancelPlaySubscription(packageName, subscriptionId, token, new FlutterCallback<Void>(null));
    }

    private void getPlaySubscriptionsStatus(MethodCall call, MethodChannel.Result result) {
        String packageName = call.argument("packageName");
        String subscriptionId = call.argument("subscriptionId");
        String token = call.argument("token");

        Backendless.Commerce.getPlaySubscriptionsStatus(packageName, subscriptionId, token, new FlutterCallback<GooglePlaySubscriptionStatus>(result));
    }

    private void validatePlayPurchase(MethodCall call, MethodChannel.Result result) {
        String packageName = call.argument("packageName");
        String productId = call.argument("productId");
        String token = call.argument("token");

        Backendless.Commerce.validatePlayPurchase(packageName, productId, token, new FlutterCallback<GooglePlayPurchaseStatus>(result));
    }
}
