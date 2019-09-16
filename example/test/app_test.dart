import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('app should work', (WidgetTester tester) async {
    await tester.pumpWidget(new MyApp());
  });
}
