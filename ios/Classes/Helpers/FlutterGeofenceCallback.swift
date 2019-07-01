//
//  FlutterGeofenceCallback.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 6/13/19.
//

import Foundation
import Backendless

// MARK: -
// MARK: - FlutterGeofenceCallback
class FlutterGeofenceCallback: IGeofenceCallback {
    
    // MARK: -
    // MARK: - Constants
    private struct Args {
        static let handle = "handle"
        static let geofenceName = "geofenceName"
        static let geofenceId = "geofenceId"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let method = "method"
    }
    
    private enum Method: String {
        case geoPointEntered
        case geoPointStayed
        case geoPointExited
    }
    
    private let callbackMethod = "Backendless.Geo.GeofenceMonitoring"
    
    // MARK: -
    // MARK: - Handle
    private let handle: Int
    
    // MARK: -
    // MARK: - FlutterMessagingChannel
    private let geoChannel: FlutterMethodChannel
    
    init(_ handle: Int, _ geoChannel: FlutterMethodChannel) {
        self.handle = handle
        self.geoChannel = geoChannel
    }
    
    func geoPointEntered(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double) {
        invokeMethod(geofenceName: geoFenceName, geofenceId: geoFenceId, latitude: latitude, longitude: longitude, method: .geoPointEntered)
    }
    
    func geoPointStayed(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double) {
        invokeMethod(geofenceName: geoFenceName, geofenceId: geoFenceId, latitude: latitude, longitude: longitude, method: .geoPointStayed)
    }
    
    func geoPointExited(geoFenceName: String, geoFenceId: String, latitude: Double, longitude: Double) {
        invokeMethod(geofenceName: geoFenceName, geofenceId: geoFenceId, latitude: latitude, longitude: longitude, method: .geoPointExited)
    }
    
    private func invokeMethod(geofenceName: String, geofenceId: String, latitude: Double, longitude: Double, method: Method) {
        let callbackArgs: [String: Any] = [
            Args.handle: handle,
            Args.geofenceName: geofenceName,
            Args.geofenceId: geofenceId,
            Args.latitude: latitude,
            Args.longitude: longitude,
            Args.method: method.rawValue
        ]
        
        geoChannel.invokeMethod(callbackMethod, arguments: callbackArgs)
    }
    
    
}
