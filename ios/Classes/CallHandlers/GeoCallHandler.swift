//
//  GeoCallHandler.swift
//  Flutter-SDK
//
//  Created by Andrii Bodnar on 5/2/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter
import Backendless

class GeoCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let addCategory = "Backendless.Geo.addCategory"
        static let deleteCategory = "Backendless.Geo.deleteCategory"
        static let getCategories = "Backendless.Geo.getCategories"
        static let getGeopointCount = "Backendless.Geo.getGeopointCount"
        static let getPoints = "Backendless.Geo.getPoints"
        static let loadMetadata = "Backendless.Geo.loadMetadata"
        static let relativeFind = "Backendless.Geo.relativeFind"
        static let removePoint = "Backendless.Geo.removePoint"
        static let runOnEnterAction = "Backendless.Geo.runOnEnterAction"
        static let runOnExitAction = "Backendless.Geo.runOnExitAction"
        static let runOnStayAction = "Backendless.Geo.runOnStayAction"
        static let savePoint = "Backendless.Geo.savePoint"
        static let setLocationTrackerParameters = "Backendless.Geo.setLocationTrackerParameters"
        static let startClientGeofenceMonitoring = "Backendless.Geo.startClientGeofenceMonitoring"
        static let startServerGeofenceMonitoring = "Backendless.Geo.startServerGeofenceMonitoring"
        static let stopGeofenceMonitoring = "Backendless.Geo.stopGeofenceMonitoring"
    }
    
    private enum Args {
        static let categoryName = "categoryName"
        static let query = "query"
        static let geofenceName = "geoFenceName"
        static let geoPoint = "geoPoint"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let categories = "categories"
        static let metadata = "metadata"
        static let geoCluster = "geoCluster"
    }
    
    // MARK: -
    // MARK: - Geo Reference
    private let geo = SwiftBackendlessSdkPlugin.backendless.geo
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.addCategory:
            addCategory(arguments, result)
        case Methods.deleteCategory:
            deleteCategory(arguments, result)
        case Methods.getCategories:
            getCategories(arguments, result)
        case Methods.getGeopointCount:
            getGeopointCount(arguments, result)
        case Methods.getPoints:
            getPoints(arguments, result)
        case Methods.loadMetadata:
            loadMetadata(arguments, result)
        case Methods.relativeFind:
            relativeFind(arguments, result)
        case Methods.removePoint:
            removePoint(arguments, result)
        case Methods.runOnEnterAction:
            runOnEnterAction(arguments, result)
        case Methods.runOnExitAction:
            runOnExitAction(arguments, result)
        case Methods.runOnStayAction:
            runOnStayAction(arguments, result)
        case Methods.savePoint:
            savePoint(arguments, result)
        case Methods.setLocationTrackerParameters:
            setLocationTrackerParameters(arguments, result)
        case Methods.startClientGeofenceMonitoring:
            startClientGeofenceMonitoring(arguments, result)
        case Methods.startServerGeofenceMonitoring:
            startServerGeofenceMonitoring(arguments, result)
        case Methods.stopGeofenceMonitoring:
            stopGeofenceMonitoring(arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - AddCategory
    private func addCategory(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let categoryName: String = arguments[Args.categoryName].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        geo.addCategory(categoryName: categoryName,
            responseHandler: { (category: GeoCategory) in
                result(category)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - DeleteCategory
    private func deleteCategory(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let categoryName: String = arguments[Args.categoryName].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        geo.deleteGeoCategory(categoryName: categoryName,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - GetCategories
    private func getCategories(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        geo.getCategories(responseHandler: {
            result($0)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - GetGeopointCount
    private func getGeopointCount(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        
        // TODO: -
        // TODO: - Need to test: problem with getting BackendlessGeoQuery object from Flutter
        
        // TODO: -
        // TODO: - How to use GeofenceName?
        
        let geoQuery: BackendlessGeoQuery? = arguments[Args.query].flatMap(cast)
        let geofenceName: String? = arguments[Args.geofenceName].flatMap(cast)
        
        if let geoQuery = geoQuery {
            geo.getPointsCount(geoQuery: geoQuery,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            geo.getPointsCount(responseHandler: {
                result($0)
            }, errorHandler: {
                result(FlutterError($0))
            })
        }
    }
    
    // MARK: -
    // MARK: - GetPoints +-
    private func getPoints(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        
        // TODO: -
        // TODO: - How to use GeofenceName & GeoCluster?
        
        let geoQuery: BackendlessGeoQuery? = arguments[Args.query].flatMap(cast)
        let geofenceName: String? = arguments[Args.geofenceName].flatMap(cast)
        let geoCluster: GeoCluster? = arguments[Args.geoCluster].flatMap(cast)
        
        if let query = geoQuery {
            geo.getPoints(geoQuery: query,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            geo.getPoints(responseHandler: {
                result($0)
            }, errorHandler: {
                result(FlutterError($0))
            })
        }
    }
    
    // MARK: -
    // MARK: - Load Metadata
    private func loadMetadata(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let geoPoint: GeoPoint = arguments[Args.geoPoint].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        geo.loadMetadata(geoPoint: geoPoint,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - RelativeFind
    private func relativeFind(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        
        // TODO: -
        // TODO: - Need to test. Problems with getting BackendlessGeoQuery from Flutter
        
        guard let geoQuery: BackendlessGeoQuery = arguments[Args.query].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        geo.relativeFind(geoQuery: geoQuery,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - RemovePoint
    private func removePoint(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let geoPoint: GeoPoint = arguments[Args.geoPoint].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        geo.removeGeoPoint(geoPoint: geoPoint,
            responseHandler: {
                result(nil)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - RunOnEnterAction
    private func runOnEnterAction(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let geofenceName: String = arguments[Args.geofenceName].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let geoPoint: GeoPoint? = arguments[Args.geoPoint].flatMap(cast)
        
        if let geoPoint = geoPoint {
            geo.runOnEnterAction(geoFenceName: geofenceName, geoPoint: geoPoint,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            geo.runOnEnterAction(geoFenceName: geofenceName,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - RunOnExitAction
    private func runOnExitAction(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let geofenceName: String = arguments[Args.geofenceName].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let geoPoint: GeoPoint? = arguments[Args.geoPoint].flatMap(cast)
        
        if let geoPoint = geoPoint {
            geo.runOnExitAction(geoFenceName: geofenceName, geoPoint: geoPoint,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            geo.runOnExitAction(geoFenceName: geofenceName,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - RunOnStayAction
    private func runOnStayAction(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let geofenceName: String = arguments[Args.geofenceName].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let geoPoint: GeoPoint? = arguments[Args.geoPoint].flatMap(cast)
        
        if let geoPoint = geoPoint {
            geo.runOnStayAction(geoFenceName: geofenceName, geoPoint: geoPoint,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            geo.runOnStayAction(geoFenceName: geofenceName,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - SavePoint
    private func savePoint(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        let geoPoint: GeoPoint? = arguments[Args.geoPoint].flatMap(cast)
        
        if let geoPoint = geoPoint {
            geo.saveGeoPoint(geoPoint: geoPoint,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            let newGeoPoint = GeoPoint()
            
            arguments[Args.latitude]
                .flatMap(cast)
                .flatMap { newGeoPoint.latitude = $0 }
            
            arguments[Args.longitude]
                .flatMap(cast)
                .flatMap { newGeoPoint.longitude = $0 }
            
            arguments[Args.categories]
                .flatMap(cast)
                .flatMap { newGeoPoint.categories = $0 }
            
            arguments[Args.metadata]
                .flatMap(cast)
                .flatMap { newGeoPoint.metadata = $0 }
            
            geo.saveGeoPoint(geoPoint: newGeoPoint,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - SetLocationTrackerParameters
    private func setLocationTrackerParameters(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        
        // TODO: -
        // TODO: - No such method in iOS SDK
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - StartClientGeofenceMonitoring
    private func startClientGeofenceMonitoring(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        
        // TODO: -
        // TODO: - Using IGeofenceCallback
        
    }
    
    // MARK: -
    // MARK: - StartServerGeofenceMonitoring
    private func startServerGeofenceMonitoring(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let geoPoint: GeoPoint = arguments[Args.geoPoint].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let geofenceName: String? = arguments[Args.geofenceName].flatMap(cast)
        
        if let geofenceName = geofenceName {
            geo.startGeoFenceMonitoring(geoFenceName: geofenceName, geoPoint: geoPoint,
                responseHandler: {
                    result(nil)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            geo.startGeoFenceMonitoring(geoPoint: geoPoint,
                responseHandler: {
                    result(nil)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - StopGeofenceMonitoring
    private func stopGeofenceMonitoring(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        let geofenceName: String? = arguments[Args.geofenceName].flatMap(cast)
        
        if let geofenceName = geofenceName {
            geo.stopGeoFenceMonitoring(geoFenceName: geofenceName)
        } else {
            geo.stopGeoFenceMonitoring()
        }
        
        result(nil)
    }
    
    
}
