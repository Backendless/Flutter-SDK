// ignore_for_file: unnecessary_null_comparison

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io' as io;

class InitTest {
  static void start() {
    const defaultUrl = 'https://api.backendless.com';
    var currentHeaders = <String, String>{
      'Content-Type': 'application/json',
    };

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

        await Backendless.userService.logout();
        String expectedKey = io.Platform.isAndroid ? androidApiKey : iosApiKey;
        String? apiKey = Backendless.apiKey;

        expect(apiKey, expectedKey);
      });

      // ----
      test('App is Initialized', () async {
        bool isInitialized = Backendless.isInitialized;

        expect(isInitialized, true);
      });

      // ----
      test('Data is initialized', () async {
        bool dataIsNull = Backendless.data == null;

        expect(dataIsNull, false);
      });

      test('CustomService is initialized', () async {
        bool isNull = Backendless.customService == null;

        expect(isNull, false);
      });

      test('Cache is initialized', () async {
        bool isNull = Backendless.cache == null;

        expect(isNull, false);
      });

      test('UserService is initialized', () async {
        bool isNull = Backendless.userService == null;

        expect(isNull, false);
      });

      test('Files is initialized', () async {
        bool isNull = Backendless.files == null;

        expect(isNull, false);
      });

      // ----
      test('Messaging is initialized', () async {
        bool isNull = Backendless.messaging == null;

        expect(isNull, false);
      });

      // ----
      test('Default URL', () async {
        expect(Backendless.url, defaultUrl);
      });

      // ----
      test('Set URL', () async {
        const customUrl = 'https://test.com';

        Backendless.url = customUrl;
        expect(Backendless.url, customUrl);

        Backendless.url = defaultUrl;
        expect(Backendless.url, defaultUrl);
      });

      // ----
      test('Default Headers', () async {
        final headers = Backendless.headers;

        expect(headers, currentHeaders);
      });

      // ----
      test('Set Header by String key', () async {
        const stringKey = 'StringKey';
        const stringValue = 'StringValue';
        currentHeaders.addAll({stringKey: stringValue});

        await Backendless.setHeader(stringValue, key: stringKey);
        var actualHeaders = Backendless.headers;

        expect(actualHeaders, currentHeaders);

        // currentHeaders.remove('StringKey');
      });

      // ----
      test('Set Header by Enum key', () async {
        const stringValue = 'StringValue';
        currentHeaders.addAll({HeadersEnum.sessionTimeOut.header: stringValue});

        await Backendless.setHeader(stringValue,
            enumKey: HeadersEnum.sessionTimeOut);
        var actualHeaders = Backendless.headers;

        expect(actualHeaders, currentHeaders);
      });

      // ----
      test('Remove Header by String key', () async {
        const keyToRemove = 'StringKey';
        currentHeaders.remove(keyToRemove);

        await Backendless.removeHeader(key: keyToRemove);
        var actualHeaders = Backendless.headers;

        expect(actualHeaders, currentHeaders);
      });

      // ----
      test('Remove Header by Enum key', () async {
        currentHeaders.remove(HeadersEnum.sessionTimeOut.header);

        await Backendless.removeHeader(enumKey: HeadersEnum.sessionTimeOut);
        var actualHeaders = Backendless.headers;

        expect(actualHeaders, currentHeaders);
      });
    });
  }
}
