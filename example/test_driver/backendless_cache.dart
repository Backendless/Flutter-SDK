import 'package:test/test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

class TestCache {
  static void start() {
    group('Cache Tests', () {
      final cache = Backendless.cache;

      final stringKey = "my_string_testing_key";
      final stringValue = "my_testing_value";

      final intKey = "my_int_testing_key";
      final intValue = 42;

      final doubleKey = "my_double_testing_key";
      final doubleValue = 42.42;

      final arrayKey = "my_array_testing_key";
      final arrayValue = [-42.42, -42, -4.2, 0, 4.2, 42, 42.42];

      final hashmapKey = "my_hashmap_testing_key";
      final hashmapValue = {
        "first": "first",
        "second": 2,
        "third": 3.3,
        "fourth": "4"
      };

      test("Contains Default", () async {
        final isStoredString = await cache.contains(stringKey);
        final isStoredInt = await cache.contains(intKey);
        final isStoredDouble = await cache.contains(doubleKey);
        final isStoredArray = await cache.contains(arrayKey);
        final isStoredHashmap = await cache.contains(hashmapKey);

        expect(isStoredString, false);
        expect(isStoredInt, false);
        expect(isStoredDouble, false);
        expect(isStoredArray, false);
        expect(isStoredHashmap, false);
      });

      test("Get Default", () async {
        final cachedString = await cache.get(stringKey);
        final cachedInt = await cache.get(intKey);
        final cachedDouble = await cache.get(doubleKey);
        final cachedArray = await cache.get(arrayKey);
        final cachedHashmap = await cache.get(hashmapKey);

        expect(cachedString, isNull);
        expect(cachedInt, isNull);
        expect(cachedDouble, isNull);
        expect(cachedArray, isNull);
        expect(cachedHashmap, isNull);
      });

      test("Put And Get", () async {
        await cache.put(stringKey, stringValue);
        await cache.put(intKey, intValue);
        await cache.put(doubleKey, doubleValue);
        await cache.put(arrayKey, arrayValue);
        await cache.put(hashmapKey, hashmapValue);

        final cachedString = await cache.get(stringKey);
        final cachedInt = await cache.get(intKey);
        final cachedDouble = await cache.get(doubleKey);
        final cachedArray = await cache.get(arrayKey);
        final cachedHashmap = await cache.get(hashmapKey);

        expect(cachedString, stringValue);
        expect(cachedInt, intValue);
        expect(cachedDouble, doubleValue);
        expect(cachedArray, arrayValue);
        expect(cachedHashmap, hashmapValue);
      });

      test("Delete", () async {
        await cache.delete(stringKey);
        await cache.delete(intKey);
        await cache.delete(doubleKey);
        await cache.delete(arrayKey);
        await cache.delete(hashmapKey);

        final isStoredString = await cache.contains(stringKey);
        final isStoredInt = await cache.contains(intKey);
        final isStoredDouble = await cache.contains(doubleKey);
        final isStoredArray = await cache.contains(arrayKey);
        final isStoredHashmap = await cache.contains(hashmapKey);

        expect(isStoredString, false);
        expect(isStoredInt, false);
        expect(isStoredDouble, false);
        expect(isStoredArray, false);
        expect(isStoredHashmap, false);
      });
    });
  }
}
