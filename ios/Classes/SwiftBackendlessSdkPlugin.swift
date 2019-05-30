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
    static let customService = "backendless/custom_service"
    static let filesChannel = "backendless/files"
    static let geoChannel = "backendless/geo"
    static let loggingChannel = "backendless/logging"
    static let messagingChannel = "backendless/messaging"
    static let userServiceChannel = "backendless/user_service"
    static let rtChannel = "backendless/rt"
    
    static let allChannels = [backendlessChannel, cacheChannel, dataChannel, commerceChannel,
                              countersChannel, eventsChannel, customService, filesChannel, geoChannel,
                              loggingChannel, messagingChannel, userServiceChannel, rtChannel]
}

public class SwiftBackendlessSdkPlugin: NSObject, FlutterPlugin {
    
    static var handlers: [FlutterCallHandlerProtocol] = []
    
    static let backendless = Backendless.shared
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let readerWriter = BackendlessReaderWriter()
        let codec = FlutterStandardMethodCodec(readerWriter: readerWriter)
        let messenger = registrar.messenger()
        
        FlutterPluginChannels.allChannels
            .forEach { channelName in
                
                let channel: FlutterMethodChannel
                let handler: FlutterCallHandlerProtocol
                
                switch channelName {
                case FlutterPluginChannels.backendlessChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
                    handler = BackendlessCallHandler()
                case FlutterPluginChannels.cacheChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = CacheCallHandler()
                case FlutterPluginChannels.dataChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = DataCallHandler(methodChannel: channel)
                case FlutterPluginChannels.commerceChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = CommerceCallHandler()
                case FlutterPluginChannels.countersChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
                    handler = CountersCallHandler()
                case FlutterPluginChannels.eventsChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = EventsCallHandler()
                case FlutterPluginChannels.customService:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = CustomServiceCallHandler()
                case FlutterPluginChannels.filesChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = FilesCallHandler()
                case FlutterPluginChannels.geoChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = GeoCallHandler()
                case FlutterPluginChannels.loggingChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = LoggingCallHandler()
                case FlutterPluginChannels.messagingChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = MessagingCallHandler(messagingChannel: channel)
                case FlutterPluginChannels.userServiceChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = UserServiceCallHandler()
                case FlutterPluginChannels.rtChannel:
                    channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger, codec: codec)
                    handler = RtCallHandler(messagingChannel: channel)
                default:
                    return
                }
                
                handlers.append(handler)
                
                channel.setMethodCallHandler(handler.routeFlutterCall)
        }
    }
    
}
