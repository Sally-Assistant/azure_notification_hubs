#import <Flutter/Flutter.h>

@interface AzureNotificationHubsPlugin : NSObject<FlutterPlugin>//, UIApplicationDelegate, UNUserNotificationCenterDelegate> 
/*
// Required to register for notifications, invoked from AppDelegate
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;
// Required to register for notifications, invoked from AppDelegate
+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
// Required to register for notifications, invoked from AppDelegate
+ (void)willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler;
// Required to register for notifications, invoked from AppDelegate
+ (void)didReceiveNotificationResponse:(UNNotificationResponse *) response withCompletionHandler:(void(^)(void))completionHandler;
*/
/*
+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;
+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler;
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler;
*/
@end
