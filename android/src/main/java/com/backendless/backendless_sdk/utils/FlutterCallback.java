package com.backendless.backendless_sdk.utils;

import com.backendless.async.callback.AsyncCallback;
import com.backendless.exceptions.BackendlessFault;

import io.flutter.plugin.common.MethodChannel;

public class FlutterCallback<T> implements AsyncCallback<T> {
    private MethodChannel.Result result;

    public FlutterCallback(MethodChannel.Result result) {
        this.result = result;
    }

    @Override
    public void handleResponse(T response) {
        if (result != null)
            result.success(response);
    }

    @Override
    public void handleFault(BackendlessFault fault) {
        if (result != null)
            result.error(fault.getCode(), fault.getMessage(), fault.getDetail());
    }
}
