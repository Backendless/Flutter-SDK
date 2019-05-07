import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('backendless_sdk');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await BackendlessSdk.platformVersion, '42');
  });
}
