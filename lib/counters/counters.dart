part of backendless_sdk;

class BackendlessCounters {
  Atomic of(String counterName) => AtomicCounters(counterName);
}
