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
    
    private enum Args { }
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.cancelPlaySubscription:
            cancelPlaySubscription(arguments, result)
        case Methods.getPlaySubscriptionsStatus:
            getPlaySubscriptionsStatus(arguments, result)
        case Methods.validatePlayPurchase:
            validatePlayPurchase(arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - CancelPlaySubscription
    // MARK: - Not actual for iOS
    private func cancelPlaySubscription(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - GetPlaySubscriptionsStatus
    // MARK: - Not actual for iOS
    private func getPlaySubscriptionsStatus(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - CalidatePlayPurchase
    // MARK: - Not actual for iOS
    private func validatePlayPurchase(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
}
