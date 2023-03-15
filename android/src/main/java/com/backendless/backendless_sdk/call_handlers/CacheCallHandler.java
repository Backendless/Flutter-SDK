package com.backendless.backendless_sdk.call_handlers;

import com.backendless.Backendless;
import com.backendless.async.callback.AsyncCallback;
import com.backendless.backendless_sdk.utils.FlutterCallback;
import com.backendless.exceptions.BackendlessFault;

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
                delete(call, result);
                break;
            case "Backendless.Cache.expireAt":
                expireAt(call, result);
                break;
            case "Backendless.Cache.expireIn":
                expireIn(call, result);
                break;
            case "Backendless.Cache.get":
                get(call, result);
                break;
            case "Backendless.Cache.put":
                put(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Deprecated
    private void contains(MethodCall call, MethodChannel.Result result) {
        String key = call.argument("key");
        Backendless.Cache.contains(key, new FlutterCallback<Boolean>(result));
    }

    @Deprecated
    private void delete(MethodCall call, MethodChannel.Result result) {
        String key = call.argument("key");
        Backendless.Cache.delete(key, new FlutterCallback<>(result));
    }

    @Deprecated
    private void expireAt(MethodCall call, MethodChannel.Result result) {
        String key = call.argument("key");
        Date date = call.argument("date");
        Long timestamp = call.argument("timestamp");
        FlutterCallback<Object> callback = new FlutterCallback<>(result);
        if (date != null) {
            Backendless.Cache.expireAt(key, date, callback);
        } else if (timestamp != null) {
            Backendless.Cache.expireAt(key, timestamp, callback);
        }
    }

    @Deprecated
    private void expireIn(MethodCall call, MethodChannel.Result result) {
        String key = call.argument("key");
        Integer seconds = call.argument("seconds");
        Backendless.Cache.expireIn(key, seconds, new FlutterCallback<>(result));
    }

    @Deprecated
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

    @Deprecated
    private void put(MethodCall call, MethodChannel.Result result) {
        String key = call.argument("key");
        Object object = call.argument("object");
        Integer timeToLive = call.argument("timeToLive");

        FlutterCallback<Object> callback = new FlutterCallback<>(result);
        if (timeToLive != null) {
            Backendless.Cache.put(key, object, timeToLive, callback);
        } else {
            Backendless.Cache.put(key, object, callback);
        }
    }
}
