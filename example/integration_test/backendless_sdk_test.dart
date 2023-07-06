import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'backendless_data_map.dart';
import 'backendless_init.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('', () {
    InitTest.start();
    DataMapTest.start();
  });
}
