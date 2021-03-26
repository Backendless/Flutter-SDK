import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'backendless_sdk.dart';
import 'src/web/call_handlers/backendless.dart';
import 'src/web/call_handlers/cache.dart';
import 'src/web/call_handlers/counters.dart';
import 'src/web/call_handlers/data.dart';
import 'src/web/call_handlers/files.dart';
import 'src/web/call_handlers/logging.dart';
import 'src/web/call_handlers/messaging.dart';
import 'src/web/call_handlers/users.dart';

class BackendlessWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel cacheChannel = MethodChannel("backendless/cache",
        const StandardMethodCodec(BackendlessMessageCodec()), registrar);
    cacheChannel.setMethodCallHandler(CacheCallHandler().handleMethodCall);

    final MethodChannel backendlessChannel = MethodChannel("backendless",
        const StandardMethodCodec(BackendlessMessageCodec()), registrar);
    backendlessChannel
        .setMethodCallHandler(BackendlessCallHandler().handleMethodCall);

    final MethodChannel dataChannel = MethodChannel("backendless/data",
        const StandardMethodCodec(BackendlessMessageCodec()), registrar);
    dataChannel
        .setMethodCallHandler(DataCallHandler(dataChannel).handleMethodCall);

    final MethodChannel countersChannel = MethodChannel(
        "backendless/counters", const StandardMethodCodec(), registrar);
    countersChannel
        .setMethodCallHandler(CountersCallHandler().handleMethodCall);

    final MethodChannel filesChannel = MethodChannel("backendless/files",
        const StandardMethodCodec(BackendlessMessageCodec()), registrar);
    filesChannel.setMethodCallHandler(FilesCallHandler().handleMethodCall);

    final MethodChannel loggingChannel = MethodChannel(
        "backendless/logging", const StandardMethodCodec(), registrar);
    loggingChannel.setMethodCallHandler(LoggingCallHandler().handleMethodCall);

    final MethodChannel messagingChannel = MethodChannel(
        "backendless/messaging",
        const StandardMethodCodec(BackendlessMessageCodec()),
        registrar);
    messagingChannel.setMethodCallHandler(
        MessagingCallHandler(messagingChannel).handleMethodCall);

    final MethodChannel userServiceChannel = MethodChannel(
        "backendless/user_service",
        const StandardMethodCodec(BackendlessMessageCodec()),
        registrar);
    userServiceChannel
        .setMethodCallHandler(UserServiceCallHandler().handleMethodCall);

    // final MethodChannel testChannel = new MethodChannel("backendless/test",
    //     new StandardMethodCodec(new BackendlessMessageCodec()), registrar());
    //     testChannel.setMethodCallHandler(new TestCallHandler());
  }
}
