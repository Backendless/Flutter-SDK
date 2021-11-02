import 'dart:async';
import 'package:test/test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

class TestCounters {
  static void start() {
    group('Counters Tests', () {
      final counters = Backendless.counters;
      final counterName = "testing_name";

      test("Get Value", () async {
        final value = await counters.getValue(counterName);

        expect(value, 0);
      });

      test("Get And Increment", () async {
        final oldValue = await counters.getAndIncrement(counterName);
        final newValue = await counters.getValue(counterName);

        expect(oldValue, 0);
        expect(newValue, 1);
      });

      test("Increment And Get", () async {
        final newValue = await counters.incrementAndGet(counterName);

        expect(newValue, 2);
      });

      test("Get And Decrement", () async {
        final oldValue = await counters.getAndDecrement(counterName);
        final newValue = await counters.getValue(counterName);

        expect(oldValue, 2);
        expect(newValue, 1);
      });

      test("Decrement And Get", () async {
        final newValue = await counters.decrementAndGet(counterName);

        expect(newValue, 0);
      });

      test("Get And Add", () async {
        final valueToAdd = 42;

        final oldValue = await counters.getAndAdd(counterName, valueToAdd);
        final newValue = await counters.getValue(counterName);

        expect(oldValue, 0);
        expect(newValue, valueToAdd);
      });

      test("Add And Get", () async {
        final oldValue =
            await (counters.getValue(counterName) as FutureOr<int>);
        final valueToAdd = 21;
        final newValue = await counters.addAndGet(counterName, valueToAdd);

        expect(newValue, oldValue + valueToAdd);
      });

      test("Compare And Set", () async {
        final valueToSet = 422;

        final notUpdated =
            await counters.compareAndSet(counterName, -1, valueToSet);
        final isUpdated =
            await counters.compareAndSet(counterName, 63, valueToSet);
        final newValue = await counters.getValue(counterName);

        expect(notUpdated, false);
        expect(isUpdated, true);
        expect(newValue, valueToSet);
      });

      test("Reset", () async {
        await counters.reset(counterName);

        final value = await counters.getValue(counterName);

        expect(value, 0);
      });
    });
  }
}
