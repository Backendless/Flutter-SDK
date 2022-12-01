package com.backendless.backendless_sdk;

import android.content.Context;

import androidx.annotation.NonNull;

import com.backendless.backendless_sdk.common.FlutterBackendlessFCMService;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMethodCodec;

/**
 * BackendlessSdkPlugin
 */
public class BackendlessSdkPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {
    private MethodChannel channelBackendlessNativeApi;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        initInstance(binding.getBinaryMessenger(), binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channelBackendlessNativeApi.setMethodCallHandler(null);
        channelBackendlessNativeApi = null;
    }

    private void initInstance(BinaryMessenger messenger, Context context) {
        channelBackendlessNativeApi = new MethodChannel(messenger, "backendless/native_api");
        channelBackendlessNativeApi.setMethodCallHandler(
                (call, result) -> {
                    if(call.method.equals("onTapPushAction")){
                    }
                    else {
                        result.notImplemented();
                    }
                }
        );
        FlutterBackendlessFCMService.setMethodChannel(channelBackendlessNativeApi);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            default:
                result.notImplemented();
                break;
        }
    }
}
