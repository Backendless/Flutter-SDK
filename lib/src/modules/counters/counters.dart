part of backendless_sdk;

class BackendlessCounters {
  static const MethodChannel _channel =
      const MethodChannel('backendless/counters');

  factory BackendlessCounters() => _instance;
  static final BackendlessCounters _instance =
      new BackendlessCounters._internal();
  BackendlessCounters._internal();

  Future<int> addAndGet(String counterName, int value) => _channel.invokeMethod(
      "Backendless.Counters.addAndGet",
      <String, dynamic>{"counterName": counterName, "value": value});

  Future<bool> compareAndSet(String counterName, int expected, int updated) =>
      _channel.invokeMethod(
          "Backendless.Counters.compareAndSet", <String, dynamic>{
        "counterName": counterName,
        "expected": expected,
        "updated": updated
      });

  Future<int> decrementAndGet(String counterName) => _channel.invokeMethod(
      "Backendless.Counters.decrementAndGet",
      <String, dynamic>{"counterName": counterName});

  Future<int> getValue(String counterName) => _channel.invokeMethod(
      "Backendless.Counters.get",
      <String, dynamic>{"counterName": counterName});

  Future<int> getAndAdd(String counterName, int value) => _channel.invokeMethod(
      "Backendless.Counters.getAndAdd",
      <String, dynamic>{"counterName": counterName, "value": value});

  Future<int> getAndDecrement(String counterName) => _channel.invokeMethod(
      "Backendless.Counters.getAndDecrement",
      <String, dynamic>{"counterName": counterName});

  Future<int> getAndIncrement(String counterName) => _channel.invokeMethod(
      "Backendless.Counters.getAndIncrement",
      <String, dynamic>{"counterName": counterName});

  Future<int> incrementAndGet(String counterName) => _channel.invokeMethod(
      "Backendless.Counters.incrementAndGet",
      <String, dynamic>{"counterName": counterName});

  IAtomic of(String counterName) => new AtomicService(counterName);

  Future<void> reset(String counterName) => _channel.invokeMethod(
      "Backendless.Counters.reset",
      <String, dynamic>{"counterName": counterName});
}
