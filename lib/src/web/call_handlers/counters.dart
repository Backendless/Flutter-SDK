@JS()

library backendless_counters_web;

import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

class CountersCallHandler {

  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {    
      case "Backendless.Counters.addAndGet":
        return promiseToFuture(
          addAndGet(call.arguments['counterName'], call.arguments['value'])
        );
      case "Backendless.Counters.compareAndSet":
        return promiseToFuture(
          compareAndSet(call.arguments['counterName'], call.arguments['expected'], call.arguments['updated'])
        );
      case "Backendless.Counters.decrementAndGet":
        return promiseToFuture(
          decrementAndGet(call.arguments['counterName'])
        );
      case "Backendless.Counters.get":
        return promiseToFuture(
          getValue(call.arguments['counterName'])
        );
      case "Backendless.Counters.getAndAdd":
        return promiseToFuture(
          getAndAdd(call.arguments['counterName'], call.arguments['value'])
        );
      case "Backendless.Counters.getAndDecrement":
        return promiseToFuture(
          getAndDecrement(call.arguments['counterName'])
        );
      case "Backendless.Counters.getAndIncrement":
        return promiseToFuture(
          getAndIncrement(call.arguments['counterName'])
        );
      case "Backendless.Counters.incrementAndGet":
        return promiseToFuture(
          incrementAndGet(call.arguments['counterName'])
        );
      case "Backendless.Counters.reset":
        return promiseToFuture(
          reset(call.arguments['counterName'])
        );
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "Backendless plugin for web doesn't implement "
              "the method '${call.method}'");
    }
  }
}

@JS('Backendless.Counters.addAndGet')
external int addAndGet(String counterName, int value);

@JS('Backendless.Counters.compareAndSet')
external bool compareAndSet(String counterName, int expected, int updated);

@JS('Backendless.Counters.decrementAndGet')
external int decrementAndGet(String counterName);

@JS('Backendless.Counters.get')
external int getValue(String counterName);

@JS('Backendless.Counters.getAndAdd')
external int getAndAdd(String counterName, int value);

@JS('Backendless.Counters.getAndDecrement')
external int getAndDecrement(String counterName);

@JS('Backendless.Counters.getAndIncrement')
external int getAndIncrement(String counterName);

@JS('Backendless.Counters.incrementAndGet')
external int incrementAndGet(String counterName);

@JS('Backendless.Counters.reset')
external dynamic reset(String counterName);