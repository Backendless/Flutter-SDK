package com.backendless.backendless_sdk.call_handlers;

import com.backendless.Backendless;
import com.backendless.BackendlessInjector;
import com.backendless.async.callback.AsyncCallback;
import com.backendless.backendless_sdk.utils.FlutterCallback;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class CountersCallHandler implements MethodChannel.MethodCallHandler {

    public CountersCallHandler() {

    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        String counterName = call.argument("counterName");
        switch (call.method) {
            case ("Backendless.Counters.addAndGet"):
                addAndGet(counterName, call, result);
                break;
            case ("Backendless.Counters.compareAndSet"):
                compareAndSet(counterName, call, result);
                break;
            case ("Backendless.Counters.decrementAndGet"):
                decrementAndGet(counterName, result);
                break;
            case ("Backendless.Counters.get"):
                get(counterName, result);
                break;
            case ("Backendless.Counters.getAndAdd"):
                getAndAdd(counterName, call, result);
                break;
            case ("Backendless.Counters.getAndDecrement"):
                getAndDecrement(counterName, result);
                break;
            case ("Backendless.Counters.getAndIncrement"):
                getAndIncrement(counterName, result);
                break;
            case ("Backendless.Counters.incrementAndGet"):
                incrementAndGet(counterName, result);
                break;
            case ("Backendless.Counters.reset"):
                reset(counterName, result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Deprecated
    private void addAndGet(String counterName, MethodCall call, final MethodChannel.Result result) {
        Number value = call.argument("value");
        Backendless.Counters.addAndGet(counterName, value,  new FlutterAtomicCallback(result));
    }

    @Deprecated
    private void compareAndSet(String counterName, MethodCall call, MethodChannel.Result result) {
        Number expected = call.argument("expected");
        Number updated = call.argument("updated");
        Backendless.Counters.compareAndSet(counterName, expected, updated, new FlutterCallback<Boolean>(result));
    }

    @Deprecated
    private void decrementAndGet(String counterName, MethodChannel.Result result) {
        Backendless.Counters.decrementAndGet(counterName, new FlutterAtomicCallback(result));
    }

    @Deprecated
    private void get(String counterName, MethodChannel.Result result) {
        Backendless.Counters.get(counterName, new FlutterAtomicCallback(result));
    }

    @Deprecated
    private void getAndAdd(String counterName, MethodCall call, MethodChannel.Result result) {
        Number value = call.argument("value");
        Backendless.Counters.getAndAdd(counterName, value, new FlutterAtomicCallback(result));
    }

    @Deprecated
    private void getAndDecrement(String counterName, MethodChannel.Result result) {
        Backendless.Counters.getAndDecrement(counterName, new FlutterAtomicCallback(result));
    }

    @Deprecated
    private void getAndIncrement(String counterName, MethodChannel.Result result) {
        Backendless.Counters.getAndIncrement(counterName, new FlutterAtomicCallback(result));
    }

    @Deprecated
    private void incrementAndGet(String counterName, MethodChannel.Result result) {
        Backendless.Counters.incrementAndGet(counterName, new FlutterAtomicCallback(result));
    }

    @Deprecated
    private void reset(String counterName, MethodChannel.Result result) {
        Backendless.Counters.reset(counterName, new FlutterCallback<>(result));
    }

//    Workaround to bypass ReflectionUtil.getCallbackGenericType call in AtomicCallback
    class FlutterAtomicCallback extends FlutterCallback<Long> implements AsyncCallback<Long> {
        public FlutterAtomicCallback(MethodChannel.Result result) { super(result); }
    }
}
