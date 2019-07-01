//
//  CustomServiceCallHandler.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 5/21/19.
//

import Foundation
import Flutter
import Backendless

class CustomServiceCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let invoke = "Backendless.CustomService.invoke"
    }
    
    private enum Args {
        static let serviceName = "serviceName"
        static let method = "method"
        static let arguments = "arguments"
    }
    
    // MARK: -
    // MARK: - Counters Reference
    private let customService = SwiftBackendlessSdkPlugin.backendless.customService
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.invoke:
            invoke(arguments: arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - Invoke
    private func invoke(arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let serviceName: String = arguments[Args.serviceName].flatMap(cast),
            let method: String = arguments[Args.method].flatMap(cast),
            let parameters = arguments[Args.arguments]
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        customService.invoke(serviceName: serviceName, method: method, parameters: parameters,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
}
