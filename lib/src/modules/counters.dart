import 'package:flutter/services.dart';

class BackendlessCounters {
  static const MethodChannel _channel = const MethodChannel('backendless/counters');

  factory BackendlessCounters() => _instance;
  static final BackendlessCounters _instance = new BackendlessCounters._internal();
  BackendlessCounters._internal();

  Future<int> addAndGet(String counterName, int value) async =>
    _channel.invokeMethod("Backendless.Counters.addAndGet", <String, dynamic> {
      "counterName":counterName,
      "value":value
    });

  Future<bool> compareAndSet(String counterName, int expected, int updated) async =>
    _channel.invokeMethod("Backendless.Counters.compareAndSet", <String, dynamic> {
      "counterName":counterName,
      "expected":expected,
      "updated":updated
    });
  
  Future<int> decrementAndGet(String counterName) async =>
    _channel.invokeMethod("Backendless.Counters.decrementAndGet", <String, dynamic> {
      "counterName":counterName
    });

  Future<int> getValue(String counterName) async =>
    _channel.invokeMethod("Backendless.Counters.get", <String, dynamic> {
      "counterName":counterName
    });

  Future<int> getAndAdd(String counterName, int value) async =>
    _channel.invokeMethod("Backendless.Counters.getAndAdd", <String, dynamic> {
      "counterName":counterName,
      "value":value
    }); 

  Future<int> getAndDecrement(String counterName) async =>
    _channel.invokeMethod("Backendless.Counters.getAndDecrement", <String, dynamic> {
      "counterName":counterName
    });

  Future<int> getAndIncrement(String counterName) async =>
    _channel.invokeMethod("Backendless.Counters.getAndIncrement", <String, dynamic> {
      "counterName":counterName
    });

  Future<int> incrementAndGet(String counterName) async =>
    _channel.invokeMethod("Backendless.Counters.incrementAndGet", <String, dynamic> {
      "counterName":counterName
    });

  IAtomic of(String counterName) => new AtomicService(counterName);

  void reset(String counterName) =>
    _channel.invokeMethod("Backendless.Counters.reset", <String, dynamic> {
      "counterName":counterName
    });
}

abstract class IAtomic {

  Future<int> addAndGet(int value);

  Future<bool> compareAndSet(int expected, int updated);
  
  Future<int> decrementAndGet();

  Future<int> getValue();

  Future<int> getAndAdd(int value);

  Future<int> getAndDecrement();

  Future<int> getAndIncrement();

  Future<int> incrementAndGet();

  void reset();
}

class AtomicService implements IAtomic {
  BackendlessCounters _counters = new BackendlessCounters();
  String _counterName;

  AtomicService(String counterName) {
    _counterName = counterName;
  }

  @override
  Future<int> addAndGet(int value) => _counters.addAndGet(_counterName, value);

  @override
  Future<bool> compareAndSet(int expected, int updated) => _counters.compareAndSet(_counterName, expected, updated);

  @override
  Future<int> decrementAndGet() => _counters.decrementAndGet(_counterName);

  @override
  Future<int> getValue() => _counters.getValue(_counterName);

  @override
  Future<int> getAndAdd(int value) => _counters.getAndAdd(_counterName, value);

  @override
  Future<int> getAndDecrement() => _counters.getAndDecrement(_counterName);

  @override
  Future<int> getAndIncrement() => _counters.getAndIncrement(_counterName);

  @override
  Future<int> incrementAndGet() => _counters.incrementAndGet(_counterName);

  @override
  void reset() => _counters.reset(_counterName);
}