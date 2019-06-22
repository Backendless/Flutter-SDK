import Flutter
import UIKit
import Backendless

// MARK: -
// MARK: - FlutterPluginChannels
fileprivate enum FlutterPluginChannels: String, CaseIterable {
    case backendlessChannel = "backendless"
    case dataChannel = "backendless/data"
    case cacheChannel = "backendless/cache"
    case commerceChannel = "backendless/commerce"
    case countersChannel = "backendless/counters"
    case eventsChannel = "backendless/events"
    case customService = "backendless/custom_service"
    case filesChannel = "backendless/files"
    case geoChannel = "backendless/geo"
    case loggingChannel = "backendless/logging"
    case messagingChannel = "backendless/messaging"
    case userServiceChannel = "backendless/user_service"
    case rtChannel = "backendless/rt"
}

public class SwiftBackendlessSdkPlugin: NSObject, FlutterPlugin {
    
    static var handlers: [FlutterCallHandlerProtocol] = []
    
    static let backendless = Backendless.shared
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let readerWriter = BackendlessReaderWriter()
        let codec = FlutterStandardMethodCodec(readerWriter: readerWriter)
        let messenger = registrar.messenger()
        
        FlutterPluginChannels.allCases
            .forEach { pluginChannel in
                
                let channel: FlutterMethodChannel
                let handler: FlutterCallHandlerProtocol
                
                switch pluginChannel {
                case .backendlessChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger)
                    handler = BackendlessCallHandler()
                case .cacheChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = CacheCallHandler()
                case .dataChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = DataCallHandler(methodChannel: channel)
                case .commerceChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = CommerceCallHandler()
                case .countersChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger)
                    handler = CountersCallHandler()
                case .eventsChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = EventsCallHandler()
                case .customService:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = CustomServiceCallHandler()
                case .filesChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = FilesCallHandler()
                case .geoChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = GeoCallHandler(methodChannel: channel)
                case .loggingChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = LoggingCallHandler()
                case .messagingChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = MessagingCallHandler(messagingChannel: channel)
                case .userServiceChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = UserServiceCallHandler()
                case .rtChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = RtCallHandler(messagingChannel: channel)
                }
                
                handlers.append(handler)
                
                channel.setMethodCallHandler(handler.routeFlutterCall)
        }
    }
    
}
