/*
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <WindowsAzureMessaging/WindowsAzureMessaging.h>
#import <UserNotifications/UserNotifications.h>
*/

#import "AzureNotificationHubsPlugin.h"
#import "azure_notification_hubs-Swift.h"

@implementation AzureNotificationHubsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAzureNotificationHubsPlugin registerWithRegistrar:registrar];
}

/*
- (BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
  [SwiftAzureNotificationHubsPlugin ];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [SwiftAzureNotificationHubsPlugin ];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
  [SwiftAzureNotificationHubsPlugin userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
  [SwiftAzureNotificationHubsPlugin userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}
*/
/*
+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
  [SwiftAzureNotificationHubsPlugin didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

// Tells the delegate that the app successfully registered with Apple Push Notification service (APNs).
+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [SwiftAzureNotificationHubsPlugin didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

//
// UNUserNotificationCenterDelegate methods
//
// Asks the delegate how to handle a notification that arrived while the app was running in the  foreground.
+ (void)willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
  [SwiftAzureNotificationHubsPlugin willPresent:notification withCompletionHandler:completionHandler];
}

// Asks the delegate to process the user's response to a delivered notification.
+ (void)didReceiveNotificationResponse:(UNNotificationResponse *) response withCompletionHandler:(void(^)(void))completionHandler {
  [SwiftAzureNotificationHubsPlugin didReceive:response withCompletionHandler:completionHandler];
}
*/
@end

/*
static FlutterMethodChannel* channel;
static NSString *hubName = @"<unset>";
static NSString *connectionString = @"<unset>";
static NSString *tags = @"<unset>";

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  channel = [FlutterMethodChannel
             methodChannelWithName:@"azure_notification_hubs"
             binaryMessenger:[registrar messenger]
             ];
  
  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    // Note: this method is invoked on the UI thread.
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([self getPlatformVersion]);
    } else if ([@"init" isEqualToString:call.method]) {
      result([self init:call.arguments]);
    } else if ([@"register" isEqualToString:call.method]) {
      result([self handleRegister]);
    } else if ([@"unRegister" isEqualToString:call.method]) {
      result([self handleUnRegister]);
    } else  {
      result(FlutterMethodNotImplemented);
    }
  }];
}

//
// Platform calls
//

+ (NSString *)getPlatformVersion {
  return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)init:(id _Nullable)arguments {
  hubName = arguments[0];
  connectionString = arguments[1];
  tags = arguments[2];

  return @"Initialized!";
}

+ (NSString *)handleRegister {
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  
  UNAuthorizationOptions options =  UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
  [center requestAuthorizationWithOptions:(options) completionHandler:^(BOOL granted, NSError * _Nullable error) {
    if (error != nil) {
      [self showAlert:@"Error requesting for authorization" withTitle:@"Registration error"];
      NSLog(@"Error requesting for authorization: %@", error);
    }
  }];
  [[UIApplication sharedApplication] registerForRemoteNotifications];

  return nil;
}

+ (NSString *)handleUnRegister {
  SBNotificationHub *hub = [self getNotificationHub];
  [hub unregisterNativeWithCompletion:^(NSError* error) {
    if (error != nil) {
      [self showAlert:@"Error unregistering for push" withTitle:@"Unregistration error"];
      NSLog(@"Error unregistering for push: %@", error);
    } else {
      [self showAlert:@"Unregistered" withTitle:@"Registration Status"];
    }
  }];

  return nil;
}

//
// AppDelegate events
//

+ (void)didReceiveRemoteNotification:
  (NSDictionary *)userInfo 
  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
  NSLog(@"Received remote (silent) notification");

  [self showAlert:@"Received remote (silent) notification" withTitle:@"Notification"];

  //
  // Let the system know the silent notification has been processed.
  //
  completionHandler(UIBackgroundFetchResultNoData);
}

+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"Registered for remote notifications");
  
  NSMutableSet *parsedTags = [[NSMutableSet alloc] init];
  
  // Load and parse stored tags
  //NSString *unparsedTags = [[NSUserDefaults standardUserDefaults] valueForKey:tags];
  //if (unparsedTags.length > 0) {
    NSArray *tagsArray = [tags componentsSeparatedByString: @","];
    [parsedTags addObjectsFromArray:tagsArray];
    [self showAlert:[NSString stringWithFormat:@"%@", parsedTags] withTitle:@"Tags"];
  //}
  
  // Register the device with the Notification Hub.
  // If the device has not already been registered, this will create the registration.
  // If the device has already been registered, this will update the existing registration.
  //
  SBNotificationHub* hub = [self getNotificationHub];
  [hub registerNativeWithDeviceToken:deviceToken tags:parsedTags completion:^(NSError* error) {
    if (error != nil) {
      [self showAlert:@"Error registering for notifications" withTitle:@"Registration error"];
      NSLog(@"Error registering for notifications: %@", error);
    } else {
      [self showAlert:@"Registered" withTitle:@"Registration Status"];
    }
  }];
}

+ (void)willPresentNotification:
  (UNNotification *)notification 
  withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
  NSLog(@"Received notification while the application is in the foreground");
  
  // The system calls this delegate method when the app is in the foreground. This allows the app to handle the notification
  // itself (and potentially modify the default system behavior).
  
  // Handle the notification by displaying custom UI.
  //
  [self showAlert:@"Received notification while the application is in the foreground" withTitle:@"Notification"];
  [self showNotification:notification.request.content.userInfo];
  
  // Use 'options' to specify which default behaviors to enable.
  // - UNAuthorizationOptionBadge: Apply the notification's badge value to the app’s icon.
  // - UNAuthorizationOptionSound: Play the sound associated with the notification.
  // - UNAuthorizationOptionAlert: Display the alert using the content provided by the notification.
  //
  // In this case, do not pass UNAuthorizationOptionAlert because the notification was handled by the app.
  //
  completionHandler(UNAuthorizationOptionBadge | UNAuthorizationOptionSound);
}

+ (void)didReceiveNotificationResponse:
  (UNNotificationResponse *)response 
  withCompletionHandler:(void(^)(void))completionHandler {
  NSLog(@"Received notification while the application is in the background");
  
  // The system calls this delegate method when the user taps or responds to the system notification.
  
  // Handle the notification response by displaying custom UI
  //
  [self showAlert:@"Received notification while the application is in the background" withTitle:@"Notification"];
  [self showNotification:response.notification.request.content.userInfo];
  
  // Let the system know the response has been processed.
  //
  completionHandler();
}

//
// App logic and helpers
//
+ (SBNotificationHub *)getNotificationHub {
  return [[SBNotificationHub alloc] initWithConnectionString:connectionString notificationHubPath:hubName];
}

+ (void)showAlert:(NSString *)message withTitle:(NSString *)title {
  if (title == nil) {
    title = @"Alert";
  }
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
  [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}

+ (void)showNotification:(NSDictionary *)userInfo {
  NSString *title = nil;
  NSString *body = nil;

  for(NSString *key in [userInfo allKeys]) {
    [self showAlert:[NSString stringWithFormat:@"%@", [userInfo objectForKey:key]] withTitle:@"showNotification"];
  }
  
  NSDictionary *aps = [userInfo valueForKey:@"aps"];
  NSObject *alertObject = [aps valueForKey:@"alert"];
  if (alertObject != nil) {
    if ([alertObject isKindOfClass:[NSDictionary class]]) {
      NSDictionary *alertDict = (NSDictionary *)alertObject;
      title = [alertDict valueForKey:@"title"];
      body = [alertObject valueForKey:@"body"];
    } else if ([alertObject isKindOfClass:[NSString class]]) {
      body = (NSString *)alertObject;
    } else {
      NSLog(@"Unable to parse notification content. Unexpected format: %@", alertObject);
    }
  }
  
  if (title == nil) {
    title = @"<unset>";
  }
  
  if (body == nil) {
    body = @"<unset>";
  }
  
  [self showAlert:body withTitle:title];
}

@end
*/
