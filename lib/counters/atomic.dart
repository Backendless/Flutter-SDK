part of backendless_sdk;

abstract class Atomic {
  Future<int?> get();

  Future<void> reset();

  Future<int?> getAndIncrement();

  Future<int?> getAndDecrement();

  Future<int?> incrementAndGet();

  Future<int?> decrementAndGet();

  Future<int?> getAndAdd(int value);

  Future<int?> addAndGet(int value);

  Future<bool?> compareAndSet(int expected, int updated);
}
