import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'backendless_sdk.dart';
import 'src/web/call_handlers/backendless.dart';
import 'src/web/call_handlers/cache.dart';
import 'src/web/call_handlers/counters.dart';

class BackendlessWeb {

  static void registerWith(Registrar registrar) {    
    final MethodChannel cacheChannel = MethodChannel(
      "backendless/cache",
      const StandardMethodCodec(BackendlessMessageCodec()), 
      registrar.messenger);
    cacheChannel.setMethodCallHandler(CacheCallHandler().handleMethodCall);

    
    final MethodChannel backendlessChannel = MethodChannel(
      "backendless", 
      const StandardMethodCodec(BackendlessMessageCodec()), 
      registrar.messenger);
    backendlessChannel.setMethodCallHandler(BackendlessCallHandler().handleMethodCall);

      //   final MethodChannel dataChannel = new MethodChannel("backendless/data",
      //       new StandardMethodCodec(new BackendlessMessageCodec()), registrar.messenger);
      //   dataChannel.setMethodCallHandler(new DataCallHandler(dataChannel));

      // final MethodChannel commerceChannel = new MethodChannel("backendless/commerce",
      //     new StandardMethodCodec(new BackendlessMessageCodec()), registrar.messenger);
      // commerceChannel.setMethodCallHandler(new CommerceCallHandler());

    final MethodChannel countersChannel = MethodChannel(
      "backendless/counters", 
      const StandardMethodCodec(), 
      registrar.messenger);
    countersChannel.setMethodCallHandler(CountersCallHandler().handleMethodCall);

      // final MethodChannel customServiceChannel = new MethodChannel("backendless/custom_service",
      //     new StandardMethodCodec(new BackendlessMessageCodec()), registrar.messenger);
      // customServiceChannel.setMethodCallHandler(new CustomServiceCallHandler());

      // final MethodChannel eventsChannel = new MethodChannel("backendless/events",
      //     new StandardMethodCodec(new BackendlessMessageCodec()), registrar.messenger);
      // eventsChannel.setMethodCallHandler(new EventsCallHandler());

      // final MethodChannel filesChannel = new MethodChannel("backendless/files",
      //     new StandardMethodCodec(new BackendlessMessageCodec()), registrar.messenger);
      // filesChannel.setMethodCallHandler(new FilesCallHandler(filesChannel));

      // final MethodChannel geoChannel = new MethodChannel("backendless/geo",
      //     new StandardMethodCodec(new BackendlessMessageCodec()), registrar.messenger);
      // geoChannel.setMethodCallHandler(new GeoCallHandler(geoChannel));

      // final MethodChannel loggingChannel = new MethodChannel("backendless/logging", registrar.messenger);
      // loggingChannel.setMethodCallHandler(new LoggingCallHandler());

      // final MethodChannel messagingChannel = new MethodChannel("backendless/messaging",
      //     new StandardMethodCodec(new BackendlessMessageCodec()), registrar.messenger);
      // messagingChannel.setMethodCallHandler(new MessagingCallHandler(messagingChannel));

      // final MethodChannel rtChannel = new MethodChannel("backendless/rt",
      //     new StandardMethodCodec(new BackendlessMessageCodec()), registrar.messenger);
      // rtChannel.setMethodCallHandler(new RtCallHandler(rtChannel));

      // final MethodChannel userServiceChannel = new MethodChannel("backendless/user_service",
      //     new StandardMethodCodec(new BackendlessMessageCodec()), registrar.messenger);
      // userServiceChannel.setMethodCallHandler(new UserServiceCallHandler());

      // final MethodChannel testChannel = new MethodChannel("backendless/test",
      //     new StandardMethodCodec(new BackendlessMessageCodec()), registrar.messenger());
      //     testChannel.setMethodCallHandler(new TestCallHandler());
  }
}