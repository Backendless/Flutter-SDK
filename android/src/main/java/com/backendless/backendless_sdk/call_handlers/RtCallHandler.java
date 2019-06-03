package com.backendless.backendless_sdk.call_handlers;

import android.util.SparseArray;

import com.backendless.Backendless;
import com.backendless.async.callback.Fault;
import com.backendless.async.callback.Result;
import com.backendless.exceptions.BackendlessFault;
import com.backendless.rt.ReconnectAttempt;
import com.backendless.rt.messaging.Channel;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class RtCallHandler implements MethodChannel.MethodCallHandler {
    private MethodChannel methodChannel;
    private final SparseArray<EventResult> connectCallbacks = new SparseArray<>();
    private int nextConnectHandle = 0;
    private final SparseArray<EventResult> reconnectAttemptCallbacks = new SparseArray<>();
    private int nextReconnectAttemptHandle = 0;
    private final SparseArray<EventResult> connectErrorCallbacks = new SparseArray<>();
    private int nextConnectErrorHandle = 0;
    private final SparseArray<EventResult> disconnectCallbacks = new SparseArray<>();
    private int nextDisconnectHandle = 0;

    public RtCallHandler(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.RT.connect":
                connect(result);
                break;
            case "Backendless.RT.disconnect":
                disconnect(result);
                break;
            case "Backendless.RT.addConnectListener":
                addConnectListener(result);
                break;
            case "Backendless.RT.addReconnectAttemptListener":
                addReconnectAttemptListener(result);
                break;
            case "Backendless.RT.addConnectErrorListener":
                addConnectErrorListener(result);
                break;
            case "Backendless.RT.addDisconnectListener":
                addDisconnectListener(result);
                break;
            case "Backendless.RT.removeConnectionListeners":
                removeConnectionListeners(result);
                break;
            case "Backendless.RT.removeListener":
                removeListener(call);
                break;
            default:
                result.notImplemented();
        }
    }

    private void connect(MethodChannel.Result result) {
        Backendless.RT.connect();
        result.success(null);

    }

    private void disconnect(MethodChannel.Result result) {
        Backendless.RT.disconnect();
        result.success(null);
    }

    private void addConnectListener(MethodChannel.Result result) {
        int connectHandle = nextConnectHandle++;
        EventResult<Void> eventResult = new EventResult<>("Connect", connectHandle, false);
        Backendless.RT.addConnectListener(eventResult);
        connectCallbacks.put(connectHandle, eventResult);
        result.success(connectHandle);
    }

    private void addReconnectAttemptListener(MethodChannel.Result result) {
        int reconnectAttemptHandle = nextReconnectAttemptHandle++;
        EventResult<ReconnectAttempt> eventResult = new EventResult<>("ReconnectAttempt", reconnectAttemptHandle);
        Backendless.RT.addReconnectAttemptListener(eventResult);
        reconnectAttemptCallbacks.put(reconnectAttemptHandle, eventResult);
        result.success(reconnectAttemptHandle);
    }

    private void addConnectErrorListener(MethodChannel.Result result) {
        int connectErrorHandle = nextConnectErrorHandle++;
        EventFault eventFault = new EventFault("ConnectError", connectErrorHandle);
        Backendless.RT.addConnectErrorListener(eventFault);
        connectErrorCallbacks.put(connectErrorHandle, eventFault);
        result.success(connectErrorHandle);
    }

    private void addDisconnectListener(MethodChannel.Result result) {
        int disconnectHandle = nextDisconnectHandle++;
        EventResult<String> eventResult = new EventResult<>("Disconnect", disconnectHandle);
        Backendless.RT.addDisconnectListener(eventResult);
        disconnectCallbacks.put(disconnectHandle, eventResult);
        result.success(disconnectHandle);
    }

    private void removeConnectionListeners(MethodChannel.Result result) {
        Backendless.RT.removeConnectionListeners();
        connectCallbacks.clear();
        result.success(null);
    }

    private void removeListener(MethodCall call) {
        String callbacksName = call.argument("callbacksName");
        int handle = call.argument("handle");

        switch (callbacksName) {
            case "connect":
                removeListenerFrom(handle, connectCallbacks);
                break;
            case "reconnect":
                removeListenerFrom(handle, reconnectAttemptCallbacks);
                break;
            case "connectError":
                removeListenerFrom(handle, connectErrorCallbacks);
                break;
            case "disconnect":
                removeListenerFrom(handle, disconnectCallbacks);
                break;
        }
    }

    private void removeListenerFrom(int handle, SparseArray<EventResult> callbacks) {
        EventResult eventResult = callbacks.get(handle);
        Backendless.RT.removeListener(eventResult);
        callbacks.remove(handle);
    }


    class EventResult<T> implements Result<T> {
        private final String method;
        private int handle;
        private boolean hasResult;

        public EventResult(String method, int handle) {
            this(method, handle, true);
        }

        public EventResult(String method, int handle, boolean hasResult) {
            this.method = method;
            this.handle = handle;
            this.hasResult = hasResult;
        }

        @Override
        public void handle(T result) {
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("handle", handle);
            if (hasResult) {
                arguments.put("result", result);
            }
            methodChannel.invokeMethod("Backendless.RT." + method + ".EventResponse", arguments);
        }
    }

    class EventFault extends EventResult<BackendlessFault> implements Fault {

        public EventFault(String method, int handle) {
            super(method, handle, true);
        }
    }
}
