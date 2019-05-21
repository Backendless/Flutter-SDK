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
    // MARK: - Router
    var callRouter: FlutterMethodCallHandler?
    
    // MARK: -
    // MARK: - Init
    init() {
        setupRouter()
    }
    
    private func setupRouter() {
        callRouter = { [weak self] (call, result) in
            guard
                let self = self,
                let arguments: [String: Any] = call.arguments.flatMap(cast)
            else { return }
            
            switch call.method {
            case Methods.invoke:
                self.invoke(arguments: arguments, result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // MARK: -
    // MARK: - Invoke
    private func invoke(arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Invoke")
        
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
