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
    private enum Methods { }
    
    private enum Args { }
    
    // MARK: -
    // MARK: - Route Flutter Call
    // MARK: - All methods aren't actual for iOS
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
    
}
