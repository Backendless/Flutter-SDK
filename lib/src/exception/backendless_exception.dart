part of backendless_sdk;

class BackendlessException implements Exception {
  final String message;

  BackendlessException(this.message);
}
