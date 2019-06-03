//
//  CountersCallHandler.swift
//  Flutter-SDK
//
//  Created by Andrii Bodnar on 4/30/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter
import Backendless

class CountersCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let addAndGet = "Backendless.Counters.addAndGet"
        static let compareAndSet = "Backendless.Counters.compareAndSet"
        static let decrementAndGet = "Backendless.Counters.decrementAndGet"
        static let get = "Backendless.Counters.get"
        static let getAndAdd = "Backendless.Counters.getAndAdd"
        static let getAndDecrement = "Backendless.Counters.getAndDecrement"
        static let getAndIncrement = "Backendless.Counters.getAndIncrement"
        static let incrementAndGet = "Backendless.Counters.incrementAndGet"
        static let reset = "Backendless.Counters.reset"
    }
    
    private enum Args {
        static let counterName = "counterName"
        static let value = "value"
        static let expected = "expected"
        static let updated = "updated"
    }
    
    // MARK: -
    // MARK: - Counters Reference
    private let counters = SwiftBackendlessSdkPlugin.backendless.counters
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard
            let arguments: [String: Any] = call.arguments.flatMap(cast),
            let counterName: String = arguments[Args.counterName].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        switch call.method {
        case Methods.addAndGet:
            self.addAndGet(counterName, arguments, result)
        case Methods.compareAndSet:
            self.compareAndSet(counterName, arguments, result)
        case Methods.decrementAndGet:
            self.decrementAndGet(counterName, result)
        case Methods.get:
            self.get(counterName, result)
        case Methods.getAndAdd:
            self.getAndAdd(counterName, arguments, result)
        case Methods.getAndDecrement:
            self.getAndDecrement(counterName, result)
        case Methods.getAndIncrement:
            self.getAndIncrement(counterName, result)
        case Methods.incrementAndGet:
            self.incrementAndGet(counterName, result)
        case Methods.reset:
            self.reset(counterName, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - AddAndGet
    private func addAndGet(_ counterName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let value: Int = arguments[Args.value].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        counters.addAndGet(counterName: counterName, value: value,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - CompareAndSet
    private func compareAndSet(_ counterName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let expected: Int = arguments[Args.expected].flatMap(cast),
            let updated: Int = arguments[Args.updated].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        counters.compareAndSet(counterName: counterName, expected: expected, updated: updated,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - DecrementAndGet
    func decrementAndGet(_ counterName: String, _ result: @escaping FlutterResult) {
        counters.decrementAndGet(counterName: counterName,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Get
    private func get(_ counterName: String, _ result: @escaping FlutterResult) {
        counters.get(counterName: counterName,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - GetAndAdd
    private func getAndAdd(_ counterName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let value: Int = arguments[Args.value].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        counters.getAndAdd(counterName: counterName, value: value,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - GetAndDecrement
    private func getAndDecrement(_ counterName: String, _ result: @escaping FlutterResult) {
        counters.getAndDecrement(counterName: counterName,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - GetAndIncrement
    private func getAndIncrement(_ counterName: String, _ result: @escaping FlutterResult) {
        counters.getAndIncrement(counterName: counterName,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - IncrementAndGet
    private func incrementAndGet(_ counterName: String, _ result: @escaping FlutterResult) {
        counters.incrementAndGet(counterName: counterName,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Reset
    private func reset(_ counterName: String, _ result: @escaping FlutterResult) {
        counters.reset(counterName: counterName,
            responseHandler: {
                result(nil)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
}
