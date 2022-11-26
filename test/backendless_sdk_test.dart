import 'package:flutter_test/flutter_test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBackendlessSdkPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {}
