package com.backendless.backendless_sdk;

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

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMethodCodec;

/** BackendlessSdkPlugin */
public class BackendlessSdkPlugin {
  /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
      final MethodChannel backendlessChannel = new MethodChannel(registrar.messenger(), "backendless");
      backendlessChannel.setMethodCallHandler(new BackendlessCallHandler(registrar.context().getApplicationContext()));

      final MethodChannel dataChannel = new MethodChannel(registrar.messenger(), "backendless/data",
          new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
      dataChannel.setMethodCallHandler(new DataCallHandler(dataChannel));

      final MethodChannel cacheChannel = new MethodChannel(registrar.messenger(), "backendless/cache",
          new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
      cacheChannel.setMethodCallHandler(new CacheCallHandler());

      final MethodChannel commerceChannel = new MethodChannel(registrar.messenger(), "backendless/commerce",
          new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
      commerceChannel.setMethodCallHandler(new CommerceCallHandler());

      final MethodChannel countersChannel = new MethodChannel(registrar.messenger(), "backendless/counters");
      countersChannel.setMethodCallHandler(new CountersCallHandler());

      final MethodChannel customServiceChannel = new MethodChannel(registrar.messenger(), "backendless/custom_service",
          new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
      customServiceChannel.setMethodCallHandler(new CustomServiceCallHandler());

      final MethodChannel eventsChannel = new MethodChannel(registrar.messenger(), "backendless/events",
          new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
      eventsChannel.setMethodCallHandler(new EventsCallHandler());

      final MethodChannel filesChannel = new MethodChannel(registrar.messenger(), "backendless/files",
          new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
      filesChannel.setMethodCallHandler(new FilesCallHandler(filesChannel));

      final MethodChannel loggingChannel = new MethodChannel(registrar.messenger(), "backendless/logging");
      loggingChannel.setMethodCallHandler(new LoggingCallHandler());

      final MethodChannel messagingChannel = new MethodChannel(registrar.messenger(), "backendless/messaging",
          new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
      messagingChannel.setMethodCallHandler(new MessagingCallHandler(messagingChannel));

      final MethodChannel rtChannel = new MethodChannel(registrar.messenger(), "backendless/rt",
          new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
      rtChannel.setMethodCallHandler(new RtCallHandler(rtChannel));

      final MethodChannel userServiceChannel = new MethodChannel(registrar.messenger(), "backendless/user_service",
          new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
      userServiceChannel.setMethodCallHandler(new UserServiceCallHandler());

      final MethodChannel fcmServiceChannel = new MethodChannel(registrar.messenger(), "backendless/messaging/push");
      FlutterBackendlessFCMService.setMethodChannel(fcmServiceChannel);

      final MethodChannel testChannel = new MethodChannel(registrar.messenger(), "backendless/test",
          new StandardMethodCodec(BackendlessMessageCodec.INSTANCE));
          testChannel.setMethodCallHandler(new TestCallHandler());
  }
}
