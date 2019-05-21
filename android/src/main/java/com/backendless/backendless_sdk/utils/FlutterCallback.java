package com.backendless.backendless_sdk.utils;

import android.support.annotation.NonNull;

import com.backendless.async.callback.AsyncCallback;
import com.backendless.exceptions.BackendlessFault;

import io.flutter.plugin.common.MethodChannel;

public class FlutterCallback<T> implements AsyncCallback<T> {
    private MethodChannel.Result result;

    public FlutterCallback(@NonNull MethodChannel.Result result) {
        this.result = result;
    }

    @Override
    public void handleResponse(T response) {
        result.success(response);
    }

    @Override
    public void handleFault(BackendlessFault fault) {
        result.error(fault.getCode(), fault.getMessage(), fault.getDetail());
    }
}
