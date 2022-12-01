import 'dart:math';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io' as io;

class InitTest {
  static void start() {
    const defaultUrl = 'https://api.backendless.com';

    group('Init Tests', () {
      // ----
      test('Not Initialized App', () {
        final isInitialized = Backendless.isInitialized;

        expect(isInitialized, false);
      });

      // ----
      test('Init App Api Keys', () async {
        const appId = '756C19D2-DF82-9D99-FF9C-9BFD2F85DC00';
        const androidApiKey = 'D3514DD9-C127-4BDA-BA06-AF0DF15EBEFB';
        const iosApiKey = 'A4470C03-FC06-4009-BD47-9077033BF7F6';

        await Backendless.initApp(
          applicationId: appId,
          androidApiKey: androidApiKey,
          iosApiKey: iosApiKey,
        );

        expect(Backendless.applicationId, appId);

        String expectedKey = io.Platform.isIOS ? iosApiKey : androidApiKey;
        String? apiKey = Backendless.apiKey;

        expect(apiKey, expectedKey);
      });

      // ----
      test('App is Initialized', () {
        bool isInitialized = Backendless.isInitialized;

        expect(isInitialized, true);
      });

      // ----
      test('Default URL', () {
        expect(Backendless.url, defaultUrl);
      });

      test('Set URL', () {
        const customUrl = 'https://test.com';

        Backendless.url = customUrl;
        expect(Backendless.url, customUrl);

        Backendless.url = defaultUrl;
        expect(Backendless.url, defaultUrl);
      });
    });
  }
}
