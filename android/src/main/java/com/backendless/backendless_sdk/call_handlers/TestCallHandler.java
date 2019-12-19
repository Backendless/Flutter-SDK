package com.backendless.backendless_sdk.call_handlers;

import android.util.Log;

import com.backendless.Backendless;
import com.backendless.async.callback.AsyncCallback;
import com.backendless.async.callback.BackendlessCallback;
import com.backendless.exceptions.BackendlessFault;
import com.backendless.backendless_sdk.utils.FlutterCallback;
// import com.backendless.files.FileInfo;
// import com.backendless.geo.GeoCluster;
// import com.backendless.geo.GeoPoint;
// import com.backendless.geo.SearchMatchesResult;
// import com.backendless.messaging.MessageStatus;
// import com.backendless.messaging.PublishStatusEnum;
// import com.backendless.persistence.DataQueryBuilder;
// import com.backendless.persistence.LoadRelationsQueryBuilder;
// import com.backendless.property.ObjectProperty;

// import java.util.Date;
// import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class TestCallHandler implements MethodChannel.MethodCallHandler {

    public TestCallHandler() {
        
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.test":
                testMethod(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void testMethod(MethodCall call, MethodChannel.Result result) {
		Object value = call.argument("value");
		result.success(value);
    }
}
