part of backendless_sdk;

class BackendlessLogging {
  static const MethodChannel _channel =
      const MethodChannel('backendless/logging');

  factory BackendlessLogging() => _instance;
  static final BackendlessLogging _instance =
      new BackendlessLogging._internal();
  BackendlessLogging._internal();

  Logger getLogger(String loggerName) {
    if (loggerName.trim().isEmpty)
      throw new ArgumentError("Log name cannot be empty");
    return new Logger._(_channel, loggerName);
  }

  Future<void> flush() => _channel.invokeMethod("Backendless.Logging.flush");

  Future<void> setLogReportingPolicy(
          int numOfMessages, int timeFrequencyInSeconds) =>
      _channel.invokeMethod(
          "Backendless.Logging.setLogReportingPolicy", <String, dynamic>{
        "numOfMessages": numOfMessages,
        "timeFrequencyInSeconds": timeFrequencyInSeconds
      });
}
