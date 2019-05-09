package com.backendless.backendless_sdk.call_handlers;

import com.backendless.Backendless;
import com.backendless.backendless_sdk.utils.FlutterCallback;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class CustomServiceCallHandler implements MethodChannel.MethodCallHandler {

    public CustomServiceCallHandler() {

    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.CustomService.invoke":
                invoke(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void invoke(MethodCall call, MethodChannel.Result result) {
        String serviceName = call.argument("serviceName");
        String method = call.argument("method");
        List<Object> arguments = call.argument("arguments");

        Backendless.CustomService.invoke(serviceName, method, arguments.toArray(), new FlutterCallback<>(result));
    }
}
