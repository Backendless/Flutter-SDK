import 'dart:async';
import 'package:flutter_driver/driver_extension.dart';
import 'package:test/test.dart';

import 'backendless_static.dart';
import 'backendless_user_service.dart';
import 'backendless_cache.dart';
import 'backendless_counters.dart';
import 'backendless_file_service.dart';
import 'backendless_classes_sending.dart';
import 'backendless_geo.dart';
import 'backendless_logging.dart';
import 'backendless_messaging.dart';
import 'backendless_data_map_driven.dart';
import 'backendless_data_class_driven.dart';
import 'backendless_rt.dart';
import 'backendless_tests.reflectable.dart';

void main() {
  initializeReflectable();
  final Completer<String> completer = Completer<String>();
  enableFlutterDriverExtension(handler: (_) => completer.future);
  tearDownAll(() => completer.complete(null));

  group("", () {
    TestStatic.start();
    TestClassesSending.start();
    TestUserService.start();
    TestCache.start();
    TestCounters.start();
    TestFileService.start();
    TestGeo.start();
    TestLogging.start();
    TestMessaging.start();
    TestDataMapDriven.start();
    TestDataClassDriven.start();
    TestRT.start();
  });
}
