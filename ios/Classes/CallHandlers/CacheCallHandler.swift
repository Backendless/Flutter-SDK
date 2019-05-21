//
//  CacheCallHandler.swift
//  Flutter-SDK
//
//  Created by Andrii Bodnar on 4/26/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter
import Backendless

class CacheCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let contains = "Backendless.Cache.contains"
        static let delete = "Backendless.Cache.delete"
        static let expireAt = "Backendless.Cache.expireAt"
        static let expireIn = "Backendless.Cache.expireIn"
        static let get = "Backendless.Cache.get"
        static let put = "Backendless.Cache.put"
    }
    
    private enum Args {
        static let key = "key"
        static let date = "date"
        static let timestamp = "timestamp"
        static let seconds = "seconds"
        static let object = "object"
        static let timeToLive = "timeToLive"
    }
    
    // MARK: -
    // MARK: - Cache Reference
    private let cache = SwiftBackendlessSdkPlugin.backendless.cache
    
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
            case Methods.contains:
                self.contains(arguments, result)
            case Methods.delete:
                self.delete(arguments, result)
            case Methods.expireAt:
                self.expireAt(arguments, result)
            case Methods.get:
                self.get(arguments, result)
            case Methods.put:
                self.put(arguments, result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // MARK: -
    // MARK: - Contains
    private func contains(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello, contains")
        
        guard let key: String = arguments[Args.key].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        cache.contains(key: key,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Delete
    private func delete(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello, delete")
        
        guard let key: String = arguments[Args.key].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        cache.remove(key: key,
            responseHandler: {
                result(nil)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    
    }
    
    // MARK: -
    // MARK: - ExpireAt
    private func expireAt(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello, expireAt")
        
        guard
            let key: String = arguments[Args.key].flatMap(cast),
            let date: Date? = arguments[Args.date].flatMap(cast),
            let timestamp: Double? = arguments[Args.timestamp].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        if let date = date {
            cache.expireAt(key: key, date: date,
                responseHandler: {
                    result(nil)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        }
        
        if let timestamp = timestamp {
            let date = Date(timeIntervalSince1970: timestamp)
            cache.expireAt(key: key, date: date,
                responseHandler: {
                    result(nil)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - ExpireIn
    private func expireIn(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello, expireIn")
        
        guard
            let key: String = arguments[Args.key].flatMap(cast),
            let seconds: Int = arguments[Args.seconds].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        cache.expireIn(key: key, seconds: seconds,
            responseHandler: {
                result(nil)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Get
    private func get(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello, get")
        
        guard let key: String = arguments[Args.key].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        cache.get(key: key,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Put
    private func put(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello, put")
        
        guard
            let key: String = arguments[Args.key].flatMap(cast),
            let object = arguments[Args.object]
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let timeToLive: Int? = arguments[Args.timeToLive].flatMap(cast)
        
        let successHandler = {
            result(nil)
        }
        let errorHandler = { (fault: Fault) in
            result(FlutterError(fault))
        }
        
        timeToLive != nil
            ? cache.put(key: key, object: object, timeToLiveSec: timeToLive!, responseHandler: successHandler, errorHandler: errorHandler)
            : cache.put(key: key, object: object, responseHandler: successHandler, errorHandler: errorHandler)
    }
    
}
