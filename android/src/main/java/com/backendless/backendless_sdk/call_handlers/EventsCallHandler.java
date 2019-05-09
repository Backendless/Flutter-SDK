package com.backendless.backendless_sdk.call_handlers;

import com.backendless.Backendless;
import com.backendless.backendless_sdk.utils.FlutterCallback;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class EventsCallHandler implements MethodChannel.MethodCallHandler {

    public EventsCallHandler() {

    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.Events.dispatch":
                dispatch(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void dispatch(MethodCall call, MethodChannel.Result result) {
        String eventName = call.argument("eventName");
        Map eventArgs = call.argument("eventArgs");

        Backendless.Events.dispatch(eventName, eventArgs, new FlutterCallback<Map>(result));
    }
}
