import 'package:flutter/services.dart';

class BackendlessLogging {
  static const MethodChannel _channel =
      const MethodChannel('backendless/logging');

  factory BackendlessLogging() => _instance;
  static final BackendlessLogging _instance =
      new BackendlessLogging._internal();
  BackendlessLogging._internal();

  Logger getLogger(String loggerName) {
    if (loggerName == null || loggerName.trim().isEmpty)
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

class Logger {
  final MethodChannel _channel;
  final String _name;

  Logger._(this._channel, this._name);

  Future<void> debug(String message) => _invokeLoggerMethod("debug", message);

  Future<void> info(String message) => _invokeLoggerMethod("info", message);

  Future<void> warn(String message, [Exception e]) => _invokeLoggerMethod(
      "warn", message + (e != null ? " : ${e.toString()}" : ""));

  Future<void> error(String message, [Exception e]) => _invokeLoggerMethod(
      "error", message + (e != null ? " : ${e.toString()}" : ""));

  Future<void> fatal(String message, [Exception e]) => _invokeLoggerMethod(
      "fatal", message + (e != null ? " : ${e.toString()}" : ""));

  Future<void> trace(String message) => _invokeLoggerMethod("trace", message);

  Future<void> _invokeLoggerMethod(String methodName, String message) =>
      _channel.invokeMethod("Backendless.Logging.Logger", <String, dynamic>{
        "loggerName": _name,
        "methodName": methodName,
        "message": message
      });
}
