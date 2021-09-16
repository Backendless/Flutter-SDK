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
        final appId = "D7022AC3-0526-5B74-FF32-4EBB8B955800";
        final androidKey = "7397F3A9-E148-4CDB-9FCB-05765D9CFA9E";
        final iosKey = "5ED16103-D623-45AC-8778-8D08912F0446";

        await Backendless.initApp(
            applicationId: appId, androidApiKey: androidKey, iosApiKey: iosKey);

        expect(Backendless.applicationId, appId);

        final expectedKey = Platform.isIOS ? iosKey : androidKey;
        final key = Backendless.apiKey;

        expect(key, expectedKey);
      });

      // --
      test('App Is Initialized', () async {
        final isInitialized = await Backendless.isInitialized();

        expect(isInitialized, true);
      });

      // --
      test('Default URL', () async {
        expect(Backendless.url, defaultUrl);
      });

      // --
      test('Set URL', () async {
        final customUrl = "https://just.testing.url";
        await Backendless.setUrl(customUrl);

        expect(Backendless.url, customUrl);

        await Backendless.setUrl(defaultUrl);

        expect(Backendless.url, defaultUrl);
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
