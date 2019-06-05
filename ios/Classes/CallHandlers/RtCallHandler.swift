//
//  RtCallHandler.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 5/28/19.
//

import Foundation
import Flutter
import Backendless

class RtCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let connect = "Backendless.RT.connect"
        static let disconnect = "Backendless.RT.disconnect"
        static let addConnectListener = "Backendless.RT.addConnectListener"
        static let addReconnectAttemptListener = "Backendless.RT.addReconnectAttemptListener"
        static let addConnectErrorListener = "Backendless.RT.addConnectErrorListener"
        static let addDisconnectListener = "Backendless.RT.addDisconnectListener"
        static let removeConnectionListeners = "Backendless.RT.removeConnectionListeners"
        static let removeListener = "Backendless.RT.removeListener"
    }
    
    private enum Args {
        static let handle = "handle"
        static let callbacksName = "callbacksName"
    }
    
    private enum CallbackNames {
        static let connect = "connect"
        static let reconnect = "reconnect"
        static let connectError = "connectError"
        static let disconnect = "disconnect"
    }
    
    // MARK: -
    // MARK: - RT Reference
    private let realTime = SwiftBackendlessSdkPlugin.backendless.rt
    
    // MARK: -
    // MARK: -
    private var connectSubscriptions: [Int: RTSubscription] = [:]
    private var nextConnectSubscription = 0
    
    private var reconnectAttemptSubscriptions: [Int: RTSubscription] = [:]
    private var nextReconnectAttemptSubscription = 0
    
    private var connectErrorSubscriptions: [Int: RTSubscription] = [:]
    private var nextConnectErrorSubscription = 0
    
    private var disconnectSubscriptions: [Int: RTSubscription] = [:]
    private var nextDisconnectSubscription = 0
    
    // MARK: -
    // MARK: - FlutterMessagingChannel
    private let messagingChannel: FlutterMethodChannel
    
    // MARK: -
    // MARK: - Init
    init(messagingChannel: FlutterMethodChannel) {
        self.messagingChannel = messagingChannel
    }
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.connect:
            connect(arguments, result)
        case Methods.disconnect:
            disconnect(arguments, result)
        case Methods.addConnectListener:
            addConnectListener(arguments, result)
        case Methods.addReconnectAttemptListener:
            addReconnectAttemptListener(arguments, result)
        case Methods.addConnectErrorListener:
            addConnectErrorListener(arguments, result)
        case Methods.addDisconnectListener:
            addDisconnectListener(arguments, result)
        case Methods.removeConnectionListeners:
            removeConnectionListeners(arguments, result)
        case Methods.removeListener:
            removeListener(arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - Connect
    private func connect(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        result(nil)
    }
    
    // MARK: -
    // MARK: - Disconnect
    private func disconnect(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        result(nil)
    }
    
    // MARK: -
    // MARK: - Add Connect Listener
    private func addConnectListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        let currentConnectSubscription = nextConnectSubscription
        nextConnectSubscription += 1
        
        let newConnectSubscription = realTime.addConnectEventListener { [weak self] in
            let callbackArgs: [String: Any] = ["handle": currentConnectSubscription]
            
            self?.messagingChannel.invokeMethod("Backendless.RT.Connect.EventResponse", arguments: callbackArgs)
        }
        
        connectSubscriptions[currentConnectSubscription] = newConnectSubscription
        result(currentConnectSubscription)
    }
    
    // MARK: -
    // MARK: - Add Reconnect Attempt Listener
    private func addReconnectAttemptListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        let currentReconnectAttemptSubscription = nextReconnectAttemptSubscription
        nextReconnectAttemptSubscription += 1
        
        let newReconnectAttemptSubscription = realTime.addReconnectAttemptEventListener { [weak self] _ in
            let callbackArgs: [String: Any] = [
                "handle": currentReconnectAttemptSubscription,
                "result": true
            ]
            
            self?.messagingChannel.invokeMethod("Backendless.RT.ReconnectAttempt.EventResponse", arguments: callbackArgs)
        }
        
        reconnectAttemptSubscriptions[currentReconnectAttemptSubscription] = newReconnectAttemptSubscription
        result(currentReconnectAttemptSubscription)
    }
    
    // MARK: -
    // MARK: - Add Connect Error Listener
    private func addConnectErrorListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        let currentConnectErrorSubscription = nextConnectErrorSubscription
        nextConnectErrorSubscription += 1
        
        let newConnectErrorSubscription = realTime.addConnectErrorEventListener { [weak self] _ in
            let callbackArgs: [String: Any] = [
                "handle": currentConnectErrorSubscription,
                "result": true
            ]
            
            self?.messagingChannel.invokeMethod("Backendless.RT.ConnectError.EventResponse", arguments: callbackArgs)
        }
        
        connectErrorSubscriptions[currentConnectErrorSubscription] = newConnectErrorSubscription
        result(currentConnectErrorSubscription)
    }
    
    // MARK: -
    // MARK: - Add Disconnect Listener
    private func addDisconnectListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        let currentDisconnectSubscription = nextDisconnectSubscription
        nextDisconnectSubscription += 1
        
        let newDisconnectSubscription = realTime.addDisсonnectEventListener { [weak self] _ in
            let callbackArgs: [String: Any] = [
                "handle": currentDisconnectSubscription,
                "result": true
            ]
            
            self?.messagingChannel.invokeMethod("Backendless.RT.Disconnect.EventResponse", arguments: callbackArgs)
        }
        
        disconnectSubscriptions[currentDisconnectSubscription] = newDisconnectSubscription
        result(currentDisconnectSubscription)
    }
    
    // MARK: -
    // MARK: - Remove Connection Listeners
    private func removeConnectionListeners(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        realTime.removeConnectEventListeners()
        connectSubscriptions.removeAll()
        
        result(nil)
    }
    
    // MARK: -
    // MARK: - Remove Listener
    private func removeListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let handle: Int = arguments[Args.handle].flatMap(cast),
            let callbacksName: String = arguments[Args.callbacksName].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        switch callbacksName {
        case CallbackNames.connect:
            if let connectSubscription = connectSubscriptions[handle] {
                connectSubscription.stop()
                connectSubscriptions.removeValue(forKey: handle)
                result(true)
            } else {
                result(false)
            }
        case CallbackNames.disconnect:
            if let disconnectSubscription = disconnectSubscriptions[handle] {
                disconnectSubscription.stop()
                disconnectSubscriptions.removeValue(forKey: handle)
                result(true)
            } else {
                result(false)
            }
        case CallbackNames.connectError:
            if let connectErrorSubscription = connectErrorSubscriptions[handle] {
                connectErrorSubscription.stop()
                connectErrorSubscriptions.removeValue(forKey: handle)
                result(true)
            } else {
                result(false)
            }
        case CallbackNames.reconnect:
            if let reconnectAttemptSubscription = reconnectAttemptSubscriptions[handle] {
                reconnectAttemptSubscription.stop()
                reconnectAttemptSubscriptions.removeValue(forKey: handle)
                result(true)
            } else {
                result(false)
            }
        default:
            result(false)
        }
        
    }
}
