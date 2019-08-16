//
//  BackendlessCallHandler.swift
//  Flutter-SDK
//
//  Created by Andrii Bodnar on 4/25/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter

// MARK: -
// MARK: - BackendlessCallHandler
class BackendlessCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let initApp = "Backendless.initApp"
        static let getApiKey = "Backendless.getApiKey"
        static let getApplicationId = "Backendless.getApplicationId"
        static let getUrl = "Backendless.getUrl"
        static let isInitialized = "Backendless.isInitialized"
        static let setUrl = "Backendless.setUrl"
        static let getHeaders = "Backendless.getHeaders"
        static let setHeader = "Backendless.setHeader"
        static let removeHeader = "Backendless.removeHeader"
    }
    
    private enum Args {
        static let applicationId = "applicationId"
        static let apiKey = "apiKey"
        static let url = "url"
        static let key = "key"
        static let value = "value"
        static let stringKey = "stringKey"
        static let enumKey = "enumKey"
    }
    
    // MARK: - 
    // MARK: - Backendless Reference
    private let backendless = SwiftBackendlessSdkPlugin.backendless
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.initApp:
            initApp(arguments, result)
        case Methods.getApiKey:
            getApiKey(arguments, result)
        case Methods.getApplicationId:
            getApplicationId(arguments, result)
        case Methods.getUrl:
            getUrl(arguments, result)
        case Methods.isInitialized:
            isInitialized(arguments, result)
        case Methods.setUrl:
            setUrl(arguments, result)
        case Methods.getHeaders:
            getHeaders(arguments, result)
        case Methods.setHeader:
            setHeader(arguments, result)
        case Methods.removeHeader:
            removeHeader(arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - InitApp
    private func initApp(_ arguments: [String: Any], _ result: FlutterResult) {
        guard
            let applicationId: String = arguments[Args.applicationId].flatMap(cast),
            let apiKey: String = arguments[Args.apiKey].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        backendless.initApp(applicationId: applicationId, apiKey: apiKey)
        result(nil)
    }
    
    // MARK: -
    // MARK: - Get ApiKey
    private func getApiKey(_ arguments: [String: Any], _ result: FlutterResult) {
        let apiKey = backendless.getApiKey()
        result(apiKey)
    }
    
    // MARK: -
    // MARK: - Get Application Id
    private func getApplicationId(_ arguments: [String: Any], _ result: FlutterResult) {
        let id = backendless.getApplictionId()
        result(id)
    }
    
    // MARK: -
    // MARK: - Get URL
    private func getUrl(_ arguments: [String: Any], _ result: FlutterResult) {
        let url = backendless.hostUrl
        result(url)
    }
    
    // MARK: -
    // MARK: - Is Initialized
    private func isInitialized(_ arguments: [String: Any], _ result: FlutterResult) {
        let appId = backendless.getApplictionId()
        let apiKey = backendless.getApiKey()
        let isInitialized = appId != "AppId" && apiKey != "APIKey"
        
        result(isInitialized)
    }
    
    // MARK: -
    // MARK: - Set URL
    private func setUrl(_ arguments: [String: Any], _ result: FlutterResult) {
        guard let url: String = arguments[Args.url].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        backendless.hostUrl = url
        result(nil)
    }
    
    // MARK: -
    // MARK: - Get Headers
    private func getHeaders(_ arguments: [String: Any], _ result: FlutterResult) {
        let headers = backendless.getHeaders()
        result(headers)
    }
    
    // MARK: -
    // MARK: - Set Header
    private func setHeader(_ arguments: [String: Any], _ result: FlutterResult) {
        
        guard let value: String = arguments[Args.value].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let stringKey: String? = arguments[Args.stringKey].flatMap(cast)
        let enumKey: HeadersEnum? = arguments[Args.enumKey]
            .flatMap(cast)
            .flatMap { HeadersEnum(index: $0) }
        
        
        if let stringKey = stringKey {
            backendless.setHeader(key: stringKey, value: value)
        } else if let enumKey = enumKey {
            backendless.setHeader(key: enumKey.rawValue, value: value)
        } else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        result(nil)
    }
    
    // MARK: -
    // MARK: - Remove Header
    private func removeHeader(_ arguments: [String: Any], _ result: FlutterResult) {
        let stringKey: String? = arguments[Args.stringKey].flatMap(cast)
        let enumKey: HeadersEnum? = arguments[Args.enumKey]
            .flatMap(cast)
            .flatMap { HeadersEnum(index: $0) }
        
        if let stringKey = stringKey {
            backendless.removeHeader(key: stringKey)
        } else if let enumKey = enumKey {
            backendless.removeHeader(key: enumKey.rawValue)
        } else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        result(nil)
    }
}
