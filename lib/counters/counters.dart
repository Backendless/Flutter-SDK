part of '../backendless_sdk.dart';

class BackendlessCounters {
  Atomic of(String counterName) => AtomicCounters(counterName);
}
