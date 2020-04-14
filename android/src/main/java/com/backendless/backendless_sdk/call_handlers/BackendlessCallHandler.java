package com.backendless.backendless_sdk.call_handlers;

import android.content.Context;

import com.backendless.Backendless;
import com.backendless.HeadersManager;
import com.backendless.HeadersManager.HeadersEnum;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BackendlessCallHandler implements MethodChannel.MethodCallHandler {
    private Context context;

    public BackendlessCallHandler(Context context) {
        this.context = context;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.initApp":
                initApp(call, result);
                break;
            case "Backendless.getApiKey":
                getApiKey(result);
                break;
            case "Backendless.getApplicationId":
                getApplicationId(result);
                break;
            case "Backendless.getUrl":
                getUrl(result);
                break;
            case "Backendless.isInitialized":
                isInitialized(result);
                break;
            case "Backendless.setUrl":
                setUrl(call, result);
                break;
            case "Backendless.getHeaders":
                getHeaders(result);
                break;
            case "Backendless.setHeader":
                setHeader(call, result);
                break;
            case "Backendless.removeHeader":
                removeHeader(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void initApp(MethodCall call, MethodChannel.Result result) {
        String applicationId = call.argument("applicationId");
        String apiKey = call.argument("apiKey");
        Backendless.initApp(context, applicationId, apiKey);
        result.success(null);
    }

    private void getApiKey(MethodChannel.Result result) {
        result.success(Backendless.getApiKey());
    }

    private void getApplicationId(MethodChannel.Result result) {
        result.success(Backendless.getApplicationId());
    }

    private void getUrl(MethodChannel.Result result) {
        result.success(Backendless.getUrl());
    }

    private void isInitialized(MethodChannel.Result result) {
        result.success(Backendless.isInitialized());
    }

    private void setUrl(MethodCall call, MethodChannel.Result result) {
        String url = call.argument("url");
        Backendless.setUrl(url);
        result.success(null);
    }

    private void getHeaders(MethodChannel.Result result) {
        Hashtable<String, String> headers = HeadersManager.getInstance().getHeaders();
        result.success(headers);
    }

    private void setHeader(MethodCall call, MethodChannel.Result result) {
        Integer enumKeyIndex = call.argument("enumKey");
        String stringKey = call.argument("stringKey");
        String value = call.argument("value");
        if ((enumKeyIndex == null && stringKey == null) || value == null) {
            result.error("Invalid argument", "Key and value cannot be null", null);
            return;
        }

        if (stringKey != null) {
            Map<String, String> headers = new HashMap<>();
            headers.put(stringKey, value);
            HeadersManager.getInstance().setHeaders(headers);
            result.success(null);
        } else if (enumKeyIndex != null) {
            HeadersEnum headersEnum = HeadersEnum.values()[enumKeyIndex];
            HeadersManager.getInstance().addHeader(headersEnum, value);
            result.success(null);
        } else {
            result.error("Invalid argument", "Key cannot be null", null);
        }
    }

    private void removeHeader(MethodCall call, MethodChannel.Result result) {
        Integer enumKeyIndex = call.argument("enumKey");
        String stringKey = call.argument("stringKey");

        if (stringKey != null) {
            HeadersManager.getInstance().getHeaders().remove(stringKey);
            result.success(null);
        } else if (enumKeyIndex != null) {
            HeadersEnum headersEnum = HeadersEnum.values()[enumKeyIndex];
            HeadersManager.getInstance().removeHeader(headersEnum);
            result.success(null);
        } else {
            result.error("Invalid argument", "Key cannot be null", null);

        }
    }
}
