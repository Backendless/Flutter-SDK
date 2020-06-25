@JS()

library backendless_logging_web;

import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

class LoggingCallHandler {

  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {    
      case "Backendless.Logging.flush":
        return promiseToFuture(
          flush()
        );
      case "Backendless.Logging.setLogReportingPolicy":
        return Future(() => setLogReportingPolicy(call.arguments['numOfMessages'], call.arguments['timeFrequencyInSeconds']));
      case "Backendless.Logging.Logger":
        return Future(
          () => push(
            call.arguments['loggerName'],
            (call.arguments['methodName'] as String).toUpperCase(), 
            call.arguments['message'])
        );
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "Backendless plugin for web doesn't implement "
              "the method '${call.method}'");
    }
  }
}

@JS('Backendless.Logging.flush')
external dynamic flush();

@JS('Backendless.Logging.setLogReportingPolicy')
external dynamic setLogReportingPolicy(int numOfMessages, int timeFrequency);

@JS('Backendless.Logging.push')
external dynamic push(String logger, String logLevel, String message);