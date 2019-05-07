#import "BackendlessSdkPlugin.h"
#import <backendless_sdk/backendless_sdk-Swift.h>

@implementation BackendlessSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBackendlessSdkPlugin registerWithRegistrar:registrar];
}
@end
