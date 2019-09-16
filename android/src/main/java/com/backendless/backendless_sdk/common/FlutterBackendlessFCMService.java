package com.backendless.backendless_sdk.common;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import com.backendless.push.BackendlessFCMService;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class FlutterBackendlessFCMService extends BackendlessFCMService {
    private static MethodChannel channel;

    @Override
    public boolean onMessage(Context appContext, final Intent msgIntent) {
        if (channel != null && msgIntent != null) {
            new Handler(getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("onMessage", bundleToMap(msgIntent.getExtras()));
                }
            });
        }

        return true;
    }

    public static void setMethodChannel(MethodChannel methodChannel) {
        channel = methodChannel;
    }

    public Map<String, Object> bundleToMap(Bundle extras) {
        Map<String, Object> map = new HashMap<>();
        for (String key : extras.keySet()) {
            map.put(key, extras.get(key));
        }
        return map;
    }
}
