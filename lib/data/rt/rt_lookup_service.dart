import 'package:backendless_sdk/data/rt/internet_connection.dart';
import 'package:flutter/foundation.dart';
import '../../backendless_sdk.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RTLookupService {
  static final InternetConnection _statusConnection =
      InternetConnection.instance;

  RTLookupService._();

  /*static Future<RTLookupService?> create() async {
    await _statusConnection.initialize();

    if (_statusConnection.statusInternet != ConnectivityResult.none)
      await lookup();
    else
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);

    return RTLookupService._();
  }*/

  static Future<String?> lookup() async {
    try {
      await _statusConnection.initialize();
      if (kDebugMode) {
        print(_statusConnection.statusInternet);
      }

      if (_statusConnection.statusInternet == ConnectivityResult.none) {
        throw ArgumentError.value(ExceptionMessage.noInternetConnection);
      }

      return await Invoker.get('/rt/lookup');
    } catch (ex) {
      if (kDebugMode) {
        print('Lookup failed $ex');
        print(_statusConnection.statusInternet);
      }

      ///TODO: add wait while connections is down
    }

    return null;
  }
}
