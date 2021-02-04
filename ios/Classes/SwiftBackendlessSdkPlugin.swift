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
    case loggingChannel = "backendless/logging"
    case messagingChannel = "backendless/messaging"
    case userServiceChannel = "backendless/user_service"
    case rtChannel = "backendless/rt"
    case pushChannel = "backendless/messaging/push"
    case testChannel = "backendless/test"
}

public class SwiftBackendlessSdkPlugin: NSObject, FlutterPlugin {
    
    // MARK: - Shared instance
    public static let shared = SwiftBackendlessSdkPlugin()
    
    private override init() {}
    
    // MARK: - Properties
    static var handlers: [FlutterCallHandlerProtocol] = []
    static let backendless = Backendless.shared
    private var messagingHandler: MessagingCallHandler?
    private var pushHandler: PushCallHandler?
    
    // MARK: - Register
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
                case .loggingChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = LoggingCallHandler()
                case .messagingChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    let messagingCallHandler = MessagingCallHandler(messagingChannel: channel)
                    handler = messagingCallHandler
                    SwiftBackendlessSdkPlugin.shared.messagingHandler = messagingCallHandler
                case .userServiceChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = UserServiceCallHandler()
                case .rtChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = RtCallHandler(messagingChannel: channel)
                case .pushChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    let pushCallHandler = PushCallHandler(pushChannel: channel)
                    SwiftBackendlessSdkPlugin.shared.pushHandler = pushCallHandler
                    handler = pushCallHandler
                case .testChannel:
                    channel = FlutterMethodChannel(name: pluginChannel.rawValue, binaryMessenger: messenger, codec: codec)
                    handler = TestCallHandler()
                }
                
                handlers.append(handler)
                
                channel.setMethodCallHandler(handler.routeFlutterCall)
        }
        
        registrar.addApplicationDelegate(SwiftBackendlessSdkPlugin.shared)
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SwiftBackendlessSdkPlugin.shared
            .messagingHandler
            .map { $0.didRegisterForRemotePushNotifications(withToken: deviceToken) }
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        SwiftBackendlessSdkPlugin.shared
            .pushHandler
            .map { $0.didReceiveRemoteNotification(userInfo: userInfo) }
        completionHandler(.newData)
        return true
    }
    
    
}
