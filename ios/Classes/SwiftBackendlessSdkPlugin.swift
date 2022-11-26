import Flutter
import UIKit

public class SwiftBackendlessSdkPlugin: NSObject, FlutterPlugin {
private var channel : FlutterMethodChannel

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftBackendlessSdkPlugin()
    let messenger = registrar.messenger()
    channel = FlutterMethodChannel(name: "backendless", binaryMessenger: messenger)

    channel.setMethodCallHandler(handler: handle)
      
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
            default:
                result(FlutterMethodNotImplemented)
        }
  }

   public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
       print(token)
   }

   public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         print("Received push notification:")
         for (key, value) in userInfo {
             print("* \(key): \(value)")
         }

         let state = UIApplication.shared.applicationState

         if state == .active
         {
           print("___ACTIVE")
         }
         else if state == .inactive {
           print("INACTIVE")
             channel?.invokeMethod("onTapPushAction", arguments: nil)
         }

         completionHandler(.newData)
     }
}
