//
//  TestCallHandler.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 10/7/19.
//

import Foundation
import Flutter

// MARK: -
// MARK: - BackendlessCallHandler
class TestCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let testMethod = "Backendless.test"
    }
    
    private enum Args {
        static let value = "value"
    }
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.testMethod:
            testMethod(arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func testMethod(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let value = arguments[Args.value] else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        result(value)
    }
}
