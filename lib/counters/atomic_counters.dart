part of backendless_sdk;

class AtomicCounters implements Atomic {
  final String _counterName;

  AtomicCounters(this._counterName);

  @override
  Future<int?> get() async {
    return await Invoker.get('/counters/$_counterName');
  }

  @override
  Future<void> reset() async {
    return await Invoker.put('/counters/$_counterName/reset', null);
  }

  @override
  Future<int?> getAndIncrement() async {
    return await Invoker.put('/counters/$_counterName/get/increment', null);
  }

  @override
  Future<int?> getAndDecrement() async {
    return await Invoker.put('/counters/$_counterName/get/decrement', null);
  }

  @override
  Future<int?> incrementAndGet() async {
    return await Invoker.put('/counters/$_counterName/increment/get', null);
  }

  @override
  Future<int?> decrementAndGet() async {
    return await Invoker.put('/counters/$_counterName/decrement/get', null);
  }

  @override
  Future<int?> getAndAdd(int value) async {
    return await Invoker.put(
        '/counters/$_counterName/get/incrementby?value=$value', null);
  }

  @override
  Future<int?> addAndGet(int value) async {
    return await Invoker.put(
        '/counters/$_counterName/incrementby/get?value=$value', null);
  }

  @override
  Future<bool?> compareAndSet(int expected, int updated) async {
    return await Invoker.put(
        '/counters/$_counterName/get/compareandset?expected=$expected&updatedvalue=$updated',
        null);
  }
}
