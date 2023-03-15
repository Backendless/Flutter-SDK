package com.backendless.backendless_sdk.call_handlers;

import android.content.Context;

import com.backendless.Backendless;
import com.backendless.BackendlessInjector;
import com.backendless.IHeadersManager;
import com.backendless.Invoker;
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
        String customDomain = call.argument("customDomain");

        if (customDomain != null)
            Backendless.initApp(context, customDomain);
        else
            Backendless.initApp(context, applicationId, apiKey);

        result.success(null);
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
        Map<String, String> headers = BackendlessInjector.getInstance().getHeadersManager().getHeaders();
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
            BackendlessInjector.getInstance().getHeadersManager().setHeaders(headers);
            result.success(null);
        } else if (enumKeyIndex != null) {
            IHeadersManager.HeadersEnum headersEnum = IHeadersManager.HeadersEnum.values()[enumKeyIndex];
            BackendlessInjector.getInstance().getHeadersManager().addHeader(headersEnum, value);
            result.success(null);
        } else {
            result.error("Invalid argument", "Key cannot be null", null);
        }
    }

    private void removeHeader(MethodCall call, MethodChannel.Result result) {
        Integer enumKeyIndex = call.argument("enumKey");
        String stringKey = call.argument("stringKey");

        if (stringKey != null) {
            BackendlessInjector.getInstance().getHeadersManager().getHeaders().remove(stringKey);
            result.success(null);
        } else if (enumKeyIndex != null) {
            IHeadersManager.HeadersEnum headersEnum= IHeadersManager.HeadersEnum.values()[enumKeyIndex];
            BackendlessInjector.getInstance().getHeadersManager().removeHeader(headersEnum);
            result.success(null);
        } else {
            result.error("Invalid argument", "Key cannot be null", null);
        }
    }
}
