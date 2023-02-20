import 'dart:async';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'backendless_data_map.dart';
import 'backendless_init.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('', () {
    InitTest.start();
    DataMapTest.start();
  });
}
