import Flutter
import UIKit
import Backendless

// MARK: -
// MARK: - FlutterPluginChannels
fileprivate enum FlutterPluginChannels {
    static let backendlessChannel = "backendless"
    static let dataChannel = "backendless/data"
    static let cacheChannel = "backendless/cache"
    static let commerceChannel = "backendless/commerce"
    static let countersChannel = "backendless/counters"
    static let eventsChannel = "backendless/events"
    // custom_service
    static let filesChannel = "backendless/files"
    static let geoChannel = "backendless/geo"
    static let loggingChannel = "backendless/logging"
    static let messagingChannel = "backendless/messaging"
    
    static let allChannels = [backendlessChannel, cacheChannel, dataChannel, commerceChannel,
                              countersChannel, eventsChannel, filesChannel, geoChannel,
                              loggingChannel, messagingChannel]
}

public class SwiftBackendlessSdkPlugin: NSObject, FlutterPlugin {

  static let backendless = Backendless.shared

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftBackendlessSdkPlugin()

    FlutterPluginChannels.allChannels
        .forEach { channelName in
            let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
                
            let handler: FlutterCallHandlerProtocol

            switch channelName {
            case FlutterPluginChannels.backendlessChannel:
                handler = BackendlessCallHandler()
            case FlutterPluginChannels.cacheChannel:
                handler = CacheCallHandler()
            case FlutterPluginChannels.dataChannel:
                handler = DataCallHandler()
            case FlutterPluginChannels.commerceChannel:
                handler = CommerceCallHandler()
            case FlutterPluginChannels.countersChannel:
                handler = CountersCallHandler()
            case FlutterPluginChannels.eventsChannel:
                handler = EventsCallHandler()
            case FlutterPluginChannels.filesChannel:
                handler = FilesCallHandler()
            case FlutterPluginChannels.geoChannel:
                handler = GeoCallHandler()
            default:
                return
            }
            
            channel.setMethodCallHandler(handler.callRouter)
            registrar.addMethodCallDelegate(instance, channel: channel)
        }
    
  }
}
