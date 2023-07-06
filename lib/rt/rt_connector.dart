part of backendless_sdk;

class RTConnector {
  void addConnectListener(void Function() callback) async {
    await RTListener.connectionHandler(callback);
  }

  void removeConnectListener() async {
    await RTListener.removeConnectionHandler();
  }

  ///TODO: disconnection Handler should return value in callback
  void addDisconnectListeners(void Function() callback) async {
    await RTListener.disconnectionHandler(callback);
  }

  void removeDisconnectListener() async {
    await RTListener.removeDisconnectionHandler();
  }

  //TODO: add value that will be return in callback
  void addConnectErrorListener(void Function() callback) async {
    await RTListener.connectionErrorHandler(callback);
  }

  void removeConnectErrorListener() async {
    await RTListener.removeConnectionErrorHandler();
  }

  //TODO: add value that will be return in callback
  void addReconnectListener(void Function() callback) async {
    await RTListener.reconnectHandler(callback);
  }

  void removeReconnectListener() async {
    await RTListener.removeReconnectHandler();
  }

  ///Remove all listeners(connect, disconnect, reconnect, connectError)
  void removeAllConnectionListeners() async {
    await RTListener.removeDisconnectionHandler();
    await RTListener.removeConnectionHandler();
    await RTListener.removeReconnectHandler();
    await RTListener.removeConnectionErrorHandler();
  }
}
