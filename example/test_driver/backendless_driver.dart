import 'package:flutter_driver/flutter_driver.dart';		

  void main() async {		
   final FlutterDriver driver = await FlutterDriver.connect();		
   await driver.requestData(null, timeout: const Duration(minutes: 10));		
   driver.close();		
 }