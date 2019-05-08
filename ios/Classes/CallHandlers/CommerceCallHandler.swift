//
//  CommerceCallHandler.swift
//  Flutter-SDK
//
//  Created by Andrii Bodnar on 4/30/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter
import Backendless

class CommerceCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let cancelPlaySubscription = "Backendless.Commerce.cancelPlaySubscription"
        static let getPlaySubscriptionsStatus = "Backendless.Commerce.getPlaySubscriptionsStatus"
        static let validatePlayPurchase = "Backendless.Commerce.validatePlayPurchase"
    }
    
    private enum Args {
        
    }
    
    // MARK: -
    // MARK: - Commerce Reference (Not Implemented)
//    private let commerce = SwiftBackendlessSdkPlugin.backendless.commerce
    
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
            case Methods.cancelPlaySubscription:
                self.cancelPlaySubscription(arguments, result)
            case Methods.getPlaySubscriptionsStatus:
                self.getPlaySubscriptionsStatus(arguments, result)
            case Methods.validatePlayPurchase:
                self.validatePlayPurchase(arguments, result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // MARK: -
    // MARK: - CancelPlaySubscription
    private func cancelPlaySubscription(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        fatalError("Commerce not implemented in iOS SDK")
    }
    
    // MARK: -
    // MARK: - GetPlaySubscriptionsStatus
    private func getPlaySubscriptionsStatus(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        fatalError("Commerce not implemented in iOS SDK")
    }
    
    // MARK: -
    // MARK: - CalidatePlayPurchase
    private func validatePlayPurchase(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        fatalError("Commerce not implemented in iOS SDK")
    }
}
