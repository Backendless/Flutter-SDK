import 'dart:async';
import 'dart:io' as io;

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnection {
  InternetConnection._();

  static final _instance = InternetConnection._();
  static InternetConnection get instance => _instance;
  final _connection = Connectivity();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  Future initialize() async {
    _connectivityResult = await _connection.checkConnectivity();
    _connection.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future _updateConnectionStatus(ConnectivityResult connectivityResult) async {
    _connectivityResult = connectivityResult;
  }

  ConnectivityResult get statusInternet => _connectivityResult;
}
