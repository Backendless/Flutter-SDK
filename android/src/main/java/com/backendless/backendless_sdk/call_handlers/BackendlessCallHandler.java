package com.backendless.backendless_sdk.call_handlers;

import android.content.Context;

import com.backendless.Backendless;

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
            case "Backendless.getNotificationIdGeneratorInitValue":
                getNotificationIdGeneratorInitValue(result);
                break;
            case "Backendless.getPushTemplatesAsJson":
                getPushTemplatesAsJson(result);
                break;
            case "Backendless.getUrl":
                getUrl(result);
                break;
            case "Backendless.isInitialized":
                isInitialized(result);
                break;
            case "Backendless.saveNotificationIdGeneratorState":
                saveNotificationIdGeneratorState(call, result);
                break;
            case "Backendless.savePushTemplates":
                savePushTemplates(call, result);
                break;
            case "Backendless.setUIState":
                setUIState(call, result);
                break;
            case "Backendless.setUrl":
                setUrl(call, result);
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

    private void getNotificationIdGeneratorInitValue(MethodChannel.Result result) {
        result.success(Backendless.getNotificationIdGeneratorInitValue());
    }

    private void getPushTemplatesAsJson(MethodChannel.Result result) {
        result.success(Backendless.getPushTemplatesAsJson());
    }

    private void getUrl(MethodChannel.Result result) {
        result.success(Backendless.getUrl());
    }

    private void isInitialized(MethodChannel.Result result) {
        result.success(Backendless.isInitialized());
    }

    private void saveNotificationIdGeneratorState(MethodCall call, MethodChannel.Result result) {
        int value = call.argument("value");
        Backendless.saveNotificationIdGeneratorState(value);
        result.success(null);
    }

    private void savePushTemplates(MethodCall call, MethodChannel.Result result) {
        String pushTemplatesAsJson = call.argument("pushTemplatesAsJson");
        Backendless.savePushTemplates(pushTemplatesAsJson);
        result.success(null);
    }

    private void setUIState(MethodCall call, MethodChannel.Result result) {
        String state = call.argument("state");
        Backendless.setUIState(state);
        result.success(null);
    }

    private void setUrl(MethodCall call, MethodChannel.Result result) {
        String url = call.argument("url");
        Backendless.setUrl(url);
        result.success(null);
    }
}
