#import "AzureNotificationHubsPlugin.h"
#import "azure_notification_hubs-Swift.h"

@implementation AzureNotificationHubsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAzureNotificationHubsPlugin registerWithRegistrar:registrar];
}
@end