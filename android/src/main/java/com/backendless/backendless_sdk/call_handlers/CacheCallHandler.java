package com.backendless.backendless_sdk.call_handlers;

import com.backendless.Backendless;
import com.backendless.async.callback.AsyncCallback;
import com.backendless.async.callback.BackendlessCallback;
import com.backendless.exceptions.BackendlessFault;
import com.backendless.backendless_sdk.utils.FlutterCallback;

import java.util.Date;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class CacheCallHandler implements MethodChannel.MethodCallHandler {

    public CacheCallHandler() {
        
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.Cache.contains":
                contains(call, result);
                break;
            case "Backendless.Cache.delete":
                delete(call);
                break;
            case "Backendless.Cache.expireAt":
                expireAt(call);
                break;
            case "Backendless.Cache.expireIn":
                expireIn(call);
                break;
            case "Backendless.Cache.get":
                get(call, result);
                break;
            case "Backendless.Cache.put":
                put(call);
                break;
            default:
                result.notImplemented();
        }
    }

    private void delete(MethodCall call) {
        String key = call.argument("key");
        Backendless.Cache.delete(key, new FlutterCallback<>(null));
    }

    private void contains(MethodCall call, MethodChannel.Result result) {
        String key = call.argument("key");
        Backendless.Cache.contains(key, new FlutterCallback<Boolean>(result));
    }

    private void expireAt(MethodCall call) {
        String key = call.argument("key");
        Date date = call.argument("date");
        Long timestamp = call.argument("timestamp");
        if (date != null) {
            Backendless.Cache.expireAt(key, date, new FlutterCallback<>(null));
        } else if (timestamp != null) {
            Backendless.Cache.expireAt(key, timestamp, new FlutterCallback<>(null));
        }
    }

    private void expireIn(MethodCall call) {
        String key = call.argument("key");
        Integer seconds = call.argument("seconds");
        Backendless.Cache.expireIn(key, seconds, new FlutterCallback<>(null));
    }

    private void get(MethodCall call, final MethodChannel.Result result) {
        String key = call.argument("key");
//        Pass AsyncCallback for compatibility
        Backendless.Cache.get(key, new AsyncCallback<Object>() {
            @Override
            public void handleResponse(Object response) {
                result.success(response);
            }

            @Override
            public void handleFault(BackendlessFault fault) {
                result.error(fault.getCode(), fault.getMessage(), fault.getDetail());
            }
        });
    }

    private void put(MethodCall call) {
        String key = call.argument("key");
        Object object = call.argument("object");
        Integer timeToLive = call.argument("timeToLive");

        FlutterCallback<Object> callback = new FlutterCallback<>(null);
        if (timeToLive != null) {
            Backendless.Cache.put(key, object, timeToLive, callback);
        } else {
            Backendless.Cache.put(key, object, callback);
        }
    }
}
