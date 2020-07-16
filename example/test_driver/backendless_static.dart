import 'package:test/test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'dart:io';

class TestStatic {
  static void start() {
    final defaultUrl = "https://api.backendless.com";

    group('Static Tests', () {
      final currentHeaders = Platform.isIOS
          ? <String, String>{}
          : {"api-version": "1.0", "application-type": "ANDROID"};

      // --
      test('Not Initialized App', () async {
        final isInitialized = await Backendless.isInitialized();

        expect(isInitialized, false);
      });

      // --
      test('Init App', () async {
        final appId = "A193657F-3E2D-4ADD-A450-5532F0BF09EC";
        final androidKey = "8A61E955-D8D6-CBF3-FFF8-FE53DEE02800";
        final iosKey = "6CBB8265-045A-C493-FF70-FD0908D51200";

        await Backendless.initApp(appId, androidKey, iosKey);

        expect(await Backendless.getApplicationId(), appId);

        final expectedKey = Platform.isIOS ? iosKey : androidKey;
        final key = await Backendless.getApiKey();

        expect(key, expectedKey);
      });

      // --
      test('App Is Initialized', () async {
        final isInitialized = await Backendless.isInitialized();

        expect(isInitialized, true);
      });

      // --
      test('Default URL', () async {
        expect(await Backendless.getUrl(), defaultUrl);
      });

      // --
      test('Set URL', () async {
        final customUrl = "https://just.testing.url";
        await Backendless.setUrl(customUrl);

        expect(await Backendless.getUrl(), customUrl);

        await Backendless.setUrl(defaultUrl);

        expect(await Backendless.getUrl(), defaultUrl);
      });

      // --
      test('Default Headers', () async {
        final headers = await Backendless.getHeaders();

        expect(headers, currentHeaders);
      });

      // --
      test('Set Header by String Key', () async {
        final newKey = "stringKey";
        final newValue = "stringValue";

        currentHeaders.addAll({newKey: newValue});

        await Backendless.setHeader(newValue, stringKey: newKey);
        final headers = await Backendless.getHeaders();

        expect(headers, currentHeaders);
        expect(1, 2);
      });

      // --
      // test('Set Header by Enum Key', () async {
      //   final newKey = HeadersEnum.USER_TOKEN_KEY;
      //   final newValue = "enumValue";

      //   currentHeaders.addAll({newKey.toString(): newValue});;

      //   await Backendless.setHeader(newValue, enumKey: newKey);
      //   final headers = await Backendless.getHeaders();

      //   expect(headers, currentHeaders);
      // });

      // --
      // test('Remove Header by String Key', () async {
      //   final keyToRemove = "stringKey";

      //   currentHeaders.remove(keyToRemove);

      //   await Backendless.removeHeader(stringKey: keyToRemove);
      //   final headers = await Backendless.getHeaders();

      //   expect(headers, currentHeaders);
      // });

      // --
      // test('Remove Header by Enum Key', () async {
      //   final keyToRemove = HeadersEnum.USER_TOKEN_KEY;

      //   currentHeaders.remove(keyToRemove.toString());

      //   await Backendless.removeHeader(enumKey: keyToRemove);
      //   final headers = await Backendless.getHeaders();

      //   expect(headers, currentHeaders);
      // });
    });
  }
}
