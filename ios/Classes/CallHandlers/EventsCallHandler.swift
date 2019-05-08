//
//  EventsCallHandler.swift
//  Flutter-SDK
//
//  Created by Andrii Bodnar on 4/30/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter
import Backendless

class EventsCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let dispatch = "Backendless.Events.dispatch"
    }
    
    private enum Args {
        static let eventName = "eventName"
        static let eventArgs = "eventArgs"
    }
    
    // MARK: -
    // MARK: - Events Reference
    private let events = SwiftBackendlessSdkPlugin.backendless.events
    
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
            case Methods.dispatch:
                self.dispatch(arguments, result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // MARK: -
    // MARK: - Dispatch
    private func dispatch(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Dispatch")
        
        guard
            let eventName: String = arguments[Args.eventName].flatMap(cast),
            let parameters: [String: Any] = arguments[Args.eventArgs].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        events.dispatch(name: eventName, parameters: parameters,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
        
        // TODO: Dispatch with execution type
        fatalError("Check what is execution type for event")
    }
}
