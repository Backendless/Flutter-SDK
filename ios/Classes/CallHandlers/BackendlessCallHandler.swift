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
// MARK: - Methods are called correctly ++
class BackendlessCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let initApp = "Backendless.initApp"
        static let getApiKey = "Backendless.getApiKey"
        static let getApplicationId = "Backendless.getApplicationId"
        static let getNotificationIdGeneratorInitValue = "Backendless.getNotificationIdGeneratorInitValue"
        static let getPushTemplatesAsJson = "Backendless.getPushTemplatesAsJson"
        static let getUrl = "Backendless.getUrl"
        static let isInitialized = "Backendless.isInitialized"
        static let saveNotificationIdGeneratorState = "Backendless.saveNotificationIdGeneratorState"
        static let savePushTemplates = "Backendless.savePushTemplates"
        static let setUIState = "Backendless.setUIState"
        static let setUrl = "Backendless.setUrl"
    }
    
    private enum Args {
        static let applicationId = "applicationId"
        static let apiKey = "apiKey"
        static let url = "url"
    }
    
    // MARK: - 
    // MARK: - Backendless Reference
    private let backendless = SwiftBackendlessSdkPlugin.backendless
    
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
            guard let self = self else { return }
            
            let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
            
            switch call.method {
            case Methods.initApp:
                self.initApp(arguments, result)
            case Methods.getApiKey:
                self.getApiKey(arguments, result)
            case Methods.getApplicationId:
                self.getApplicationId(arguments, result)
            case Methods.getNotificationIdGeneratorInitValue:
                self.getNotificationIdGeneratorInitValue(arguments, result)
            case Methods.getPushTemplatesAsJson:
                self.getPushTemplatesAsJson(arguments, result)
            case Methods.getUrl:
                self.getUrl(arguments, result)
            case Methods.isInitialized:
                self.isInitialized(arguments, result)
            case Methods.saveNotificationIdGeneratorState:
                self.saveNotificationIdGeneratorState(arguments, result)
            case Methods.savePushTemplates:
                self.savePushTemplates(arguments, result)
            case Methods.setUIState:
                self.setUIState(arguments, result)
            case Methods.setUrl:
                self.setUrl(arguments, result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // MARK: -
    // MARK: - InitApp
    private func initApp(_ arguments: [String: Any], _ result: FlutterResult) {
        print("~~~> Hello, init app")
        
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
        print("~~~> Hello, Get API Key")
        
        let apiKey = backendless.getApiKey()
        result(apiKey)
    }
    
    // MARK: -
    // MARK: - Get Application Id
    private func getApplicationId(_ arguments: [String: Any], _ result: FlutterResult) {
        print("~~~> Hello, Get Application Id")
        
        let id = backendless.getApplictionId()
        result(id)
    }
    
    // MARK: -
    // MARK: - Get Notification Id Generator Init Value
    private func getNotificationIdGeneratorInitValue(_ arguments: [String: Any], _ result: FlutterResult) {
        print("~~~> Hello, Get Notification Id Generator Init Value")
        
        // TODO: -
        // TODO: - No such method in iOS SDK
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Get Push Templates As Json
    private func getPushTemplatesAsJson(_ arguments: [String: Any], _ result: FlutterResult) {
        print("~~~> Hello, Get Push Templates As Json")
        
        // TODO: -
        // TODO: - No such method in iOS SDK
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Get URL
    private func getUrl(_ arguments: [String: Any], _ result: FlutterResult) {
        print("~~~> Hello, Get URL")
        
        let url = backendless.hostUrl
        result(url)
    }
    
    // MARK: -
    // MARK: - Is Initialized
    private func isInitialized(_ arguments: [String: Any], _ result: FlutterResult) {
        print("~~~> Hello, Is Initialized")
        
        // TODO: -
        // TODO: - No such method in iOS SDK
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Save Notification Id Generator State
    private func saveNotificationIdGeneratorState(_ arguments: [String: Any], _ result: FlutterResult) {
        print("~~~> Hello, saveNotificationIdGeneratorState")
        
        // TODO: -
        // TODO: - No such method in iOS SDK
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Save Push Templates
    private func savePushTemplates(_ arguments: [String: Any], _ result: FlutterResult) {
        print("~~~> Hello, Save Push Templates")
        
        // TODO: -
        // TODO: - No such method in iOS SDK
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Set UI State
    private func setUIState(_ arguments: [String: Any], _ result: FlutterResult) {
        print("~~~> Hello, Set UI State")
        
        // TODO: -
        // TODO: - No such method in iOS SDK
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Set URL
    private func setUrl(_ arguments: [String: Any], _ result: FlutterResult) {
        print("~~~> Hello, Set URL")
        
        guard let url: String = arguments[Args.url].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        backendless.hostUrl = url
        result(nil)
    }
}
