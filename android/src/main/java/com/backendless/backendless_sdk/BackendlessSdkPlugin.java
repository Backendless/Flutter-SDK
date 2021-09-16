package com.backendless.backendless_sdk;

import android.content.Context;

import androidx.annotation.NonNull;

import com.backendless.backendless_sdk.call_handlers.BackendlessCallHandler;
import com.backendless.backendless_sdk.call_handlers.CacheCallHandler;
import com.backendless.backendless_sdk.call_handlers.CommerceCallHandler;
import com.backendless.backendless_sdk.call_handlers.CountersCallHandler;
import com.backendless.backendless_sdk.call_handlers.CustomServiceCallHandler;
import com.backendless.backendless_sdk.call_handlers.DataCallHandler;
import com.backendless.backendless_sdk.call_handlers.EventsCallHandler;
import com.backendless.backendless_sdk.call_handlers.FilesCallHandler;
import com.backendless.backendless_sdk.call_handlers.LoggingCallHandler;
import com.backendless.backendless_sdk.call_handlers.MessagingCallHandler;
import com.backendless.backendless_sdk.call_handlers.RtCallHandler;
import com.backendless.backendless_sdk.call_handlers.UserServiceCallHandler;
import com.backendless.backendless_sdk.common.FlutterBackendlessFCMService;
import com.backendless.backendless_sdk.call_handlers.TestCallHandler;
import com.backendless.backendless_sdk.utils.codec.BackendlessMessageCodec;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMethodCodec;

/**
 * BackendlessSdkPlugin
 */
public class BackendlessSdkPlugin implements FlutterPlugin {
    private MethodChannel backendlessChannel;
    private MethodChannel dataChannel;
    private MethodChannel cacheChannel;
    private MethodChannel commerceChannel;
    private MethodChannel countersChannel;
    private MethodChannel customServiceChannel;
    private MethodChannel eventsChannel;
    private MethodChannel filesChannel;
    private MethodChannel loggingChannel;
    private MethodChannel messagingChannel;
    private MethodChannel rtChannel;
    private MethodChannel userServiceChannel;
    private MethodChannel fcmServiceChannel;
    private MethodChannel testChannel;

    @SuppressWarnings("deprecation")
    public static void registerWith(PluginRegistry.Registrar registrar) {
        BackendlessSdkPlugin plugin = new BackendlessSdkPlugin();
        plugin.initInstance(registrar.messenger(), registrar.context().getApplicationContext());
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        initInstance(binding.getBinaryMessenger(), binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        backendlessChannel.setMethodCallHandler(null);
        backendlessChannel = null;
        dataChannel.setMethodCallHandler(null);
        dataChannel = null;
        cacheChannel.setMethodCallHandler(null);
        cacheChannel = null;
        commerceChannel.setMethodCallHandler(null);
        commerceChannel = null;
        countersChannel.setMethodCallHandler(null);
        countersChannel = null;
        customServiceChannel.setMethodCallHandler(null);
        customServiceChannel = null;
        eventsChannel.setMethodCallHandler(null);
        eventsChannel = null;
        filesChannel.setMethodCallHandler(null);
        filesChannel = null;
        loggingChannel.setMethodCallHandler(null);
        loggingChannel = null;
        messagingChannel.setMethodCallHandler(null);
        messagingChannel = null;
        rtChannel.setMethodCallHandler(null);
        rtChannel = null;
        userServiceChannel.setMethodCallHandler(null);
        userServiceChannel = null;
        fcmServiceChannel.setMethodCallHandler(null);
        fcmServiceChannel = null;
        testChannel.setMethodCallHandler(null);
        testChannel = null;
    }

    private void initInstance(BinaryMessenger messenger, Context context) {
        backendlessChannel = new MethodChannel(messenger, "backendless");
        backendlessChannel.setMethodCallHandler(new BackendlessCallHandler(context));

        dataChannel = new MethodChannel(messenger, "backendless/data",
                new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
        dataChannel.setMethodCallHandler(new DataCallHandler(dataChannel));

        cacheChannel = new MethodChannel(messenger, "backendless/cache",
                new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
        cacheChannel.setMethodCallHandler(new CacheCallHandler());

        commerceChannel = new MethodChannel(messenger, "backendless/commerce",
                new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
        commerceChannel.setMethodCallHandler(new CommerceCallHandler());

        countersChannel = new MethodChannel(messenger, "backendless/counters");
        countersChannel.setMethodCallHandler(new CountersCallHandler());

        customServiceChannel = new MethodChannel(messenger, "backendless/custom_service",
                new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
        customServiceChannel.setMethodCallHandler(new CustomServiceCallHandler());

        eventsChannel = new MethodChannel(messenger, "backendless/events",
                new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
        eventsChannel.setMethodCallHandler(new EventsCallHandler());

        filesChannel = new MethodChannel(messenger, "backendless/files",
                new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
        filesChannel.setMethodCallHandler(new FilesCallHandler(filesChannel));

        loggingChannel = new MethodChannel(messenger, "backendless/logging");
        loggingChannel.setMethodCallHandler(new LoggingCallHandler());

        messagingChannel = new MethodChannel(messenger, "backendless/messaging",
                new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
        messagingChannel.setMethodCallHandler(new MessagingCallHandler(messagingChannel));

        rtChannel = new MethodChannel(messenger, "backendless/rt",
                new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
        rtChannel.setMethodCallHandler(new RtCallHandler(rtChannel));

        userServiceChannel = new MethodChannel(messenger, "backendless/user_service",
                new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
        userServiceChannel.setMethodCallHandler(new UserServiceCallHandler());

        fcmServiceChannel = new MethodChannel(messenger, "backendless/messaging/push");
        FlutterBackendlessFCMService.setMethodChannel(fcmServiceChannel);

        testChannel = new MethodChannel(messenger, "backendless/test",
                new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
        testChannel.setMethodCallHandler(new TestCallHandler());
    }
}
