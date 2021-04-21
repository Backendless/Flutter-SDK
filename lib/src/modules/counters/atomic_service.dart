part of backendless_sdk;

abstract class IAtomic {
  Future<int?> addAndGet(int value);

  Future<bool?> compareAndSet(int expected, int updated);

  Future<int?> decrementAndGet();

  Future<int?> getValue();

  Future<int?> getAndAdd(int value);

  Future<int?> getAndDecrement();

  Future<int?> getAndIncrement();

  Future<int?> incrementAndGet();

  Future<void> reset();
}

class AtomicService implements IAtomic {
  BackendlessCounters _counters = new BackendlessCounters();
  String _counterName;

  AtomicService(this._counterName);

  @override
  Future<int?> addAndGet(int value) => _counters.addAndGet(_counterName, value);

  @override
  Future<bool?> compareAndSet(int expected, int updated) =>
      _counters.compareAndSet(_counterName, expected, updated);

  @override
  Future<int?> decrementAndGet() => _counters.decrementAndGet(_counterName);

  @override
  Future<int?> getValue() => _counters.getValue(_counterName);

  @override
  Future<int?> getAndAdd(int value) => _counters.getAndAdd(_counterName, value);

  @override
  Future<int?> getAndDecrement() => _counters.getAndDecrement(_counterName);

  @override
  Future<int?> getAndIncrement() => _counters.getAndIncrement(_counterName);

  @override
  Future<int?> incrementAndGet() => _counters.incrementAndGet(_counterName);

  @override
  Future<void> reset() => _counters.reset(_counterName);
}
