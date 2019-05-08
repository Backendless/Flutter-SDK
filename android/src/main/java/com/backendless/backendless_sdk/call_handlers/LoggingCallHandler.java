package com.backendless.backendless_sdk.call_handlers;

import com.backendless.Backendless;
import com.backendless.logging.Logger;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class LoggingCallHandler implements MethodChannel.MethodCallHandler {
    private Map<String, Logger> loggers = new HashMap<>();

    public LoggingCallHandler() {

    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "Backendless.Logging.flush":
                flush();
                break;
            case "Backendless.Logging.setLogReportingPolicy":
                setLogReportingPolicy(call);
                break;
            case "Backendless.Logging.Logger":
                invokeLoggerMethod(call);
                break;
            default:
                result.notImplemented();
        }
    }

    private void flush() {
        Backendless.Logging.flush();
    }

    private void setLogReportingPolicy(MethodCall call) {
        Integer numOfMessages = call.argument("numOfMessages");
        Integer timeFrequencyInSeconds = call.argument("timeFrequencyInSeconds");

        Backendless.Logging.setLogReportingPolicy(numOfMessages, timeFrequencyInSeconds);
    }

    private void invokeLoggerMethod(MethodCall call) {
        String loggerName = call.argument("loggerName");
        String methodName = call.argument("methodName");
        String message = call.argument("message");


        Logger logger;
        if (loggers.containsKey(loggerName) && loggers.get(loggerName) != null) {
            logger = loggers.get(loggerName);
        } else {
            logger = Backendless.Logging.getLogger(loggerName);
            loggers.put(loggerName, logger);
        }

        switch (methodName) {
            case "debug":
                logger.debug(message);
                break;
            case "info":
                logger.info(message);
                break;
            case "warn":
                logger.warn(message);
                break;
            case "error":
                logger.error(message);
                break;
            case "fatal":
                logger.fatal(message);
                break;
            case "trace":
                logger.trace(message);
                break;
            default:
                throw new IllegalArgumentException("Wrong Logger method name");
        }
    }
}
