//
//  PushCallHandler.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 9/12/19.
//

import Foundation

class PushCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: - Channel
    private let pushChannel: FlutterMethodChannel
    
    // MARK: - Init
    init(pushChannel: FlutterMethodChannel) {
        self.pushChannel = pushChannel
    }
    
    /// No incoming actions.
    /// Just outcoming
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) { }
    
    // MARK: - OnMessage
    func didReceiveRemoteNotification(userInfo: [AnyHashable : Any]) {
        var mappedInfo: [String: Any] = [:]
        
        userInfo.forEach { k, v in
            let stringKey = k is String ? (k as! String) : "\(k)"
            mappedInfo[stringKey] = v
        }
        
        pushChannel.invokeMethod("onMessage", arguments: mappedInfo)
    }
}
