//
//  LoggingCallHandler.swift
//  BackendlessSwiftPlugin
//
//  Created by Andrii Bodnar on 5/2/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter
import Backendless

class LoggingCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let flush = "Backendless.Logging.flush"
        static let setLogReportingPolicy = "Backendless.Logging.setLogReportingPolicy"
        static let invokeLoggerMethod = "Backendless.Logging.Logger"
    }
    
    private enum Args {
        static let numOfMessages = "numOfMessages"
        static let timeFrequencyInSeconds = "timeFrequencyInSeconds"
        static let loggerName = "loggerName"
        static let methodName = "methodName"
        static let message = "message"
    }
    
    // MARK: -
    // MARK: - LoggerMethods
    private enum LoggerMethods: String {
        case debug
        case info
        case warn
        case error
        case fatal
        case trace
    }
    
    // MARK: -
    // MARK: - Logging Reference
    private let logging = SwiftBackendlessSdkPlugin.backendless.logging
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.flush:
            flush(arguments, result)
        case Methods.setLogReportingPolicy:
            setLogReportingPolicy(arguments, result)
        case Methods.invokeLoggerMethod:
            invokeLoggerMethod(arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - Flush
    private func flush(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        logging.flush()
        
        result(nil)
    }
    
    // MARK: -
    // MARK: - SetLogReportingPolicy
    private func setLogReportingPolicy(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let numOfMessages: Int = arguments[Args.numOfMessages].flatMap(cast),
            let timeFrequencyInSeconds: Int = arguments[Args.timeFrequencyInSeconds].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        logging.setLogReportingPolicy(numberOfMessages: numOfMessages, timeFrequencySec: timeFrequencyInSeconds)
        
        result(nil)
    }
    
    // MARK: -
    // MARK: - InvokeLoggerMethod
    private func invokeLoggerMethod(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let loggerName: String = arguments[Args.loggerName].flatMap(cast),
            let methodName: String = arguments[Args.methodName].flatMap(cast),
            let message: String = arguments[Args.message].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let logger = logging.getLogger(loggerName: loggerName)
        
        guard let method = LoggerMethods(rawValue: methodName) else {
            let error = FlutterError(code: "", message: "Wrong Logger method name", details: nil)
            result(error)
            
            return
        }
        
        switch method {
        case .debug:
            logger.debug(message: message)
        case .info:
            logger.info(message: message)
        case .warn:
            logger.warn(message: message)
        case .error:
            logger.error(message: message)
        case .fatal:
            logger.fatal(message: message)
        case .trace:
            logger.trace(message: message)
        }
        
        result(nil)
    }
    
}
