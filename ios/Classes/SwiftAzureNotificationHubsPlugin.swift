import Flutter
import UIKit
import UserNotifications

@available(iOS 10.0, *)
public class SwiftAzureNotificationHubsPlugin: NSObject, FlutterPlugin, UNUserNotificationCenterDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "azure_notification_hubs", binaryMessenger: registrar.messenger())
    let instance = SwiftAzureNotificationHubsPlugin(channel: channel, registrar: registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
    //UNUserNotificationCenter.current().delegate = instance
  }

  //
  // Variables
  //
  private var _channel: FlutterMethodChannel
  private var _registrar: FlutterPluginRegistrar

  // Constants
  var NHInfoConnectionString = "NotificationHubConnectionString"
  var NHInfoHubName = "NotificationHubName"
  var tags = "notification_tags"

  //
  // Constructor
  //
  init(channel: FlutterMethodChannel, registrar: FlutterPluginRegistrar) {
    _channel = channel
    _registrar = registrar
    super.init()
  }

  //
  // Public Functions
  //

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "init":
      _init(arguments: call.arguments as? [Any])
      result(nil)
    case "register":
      _handleRegister()
      result(nil)
    case "unregister":
      _handleUnregister()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  //
  // Platform calls
  //
  private func _init(arguments: [Any]!) {
    NHInfoConnectionString = arguments[0] as! String
    NHInfoHubName = arguments[1] as! String
    tags = arguments[2] as! String
    self.showAlert("\(NHInfoConnectionString)", withTitle: "Connection String")
  }

  private func _handleRegister() {
    UNUserNotificationCenter.current()
      .requestAuthorization(options: [.alert, .sound, .badge]) {
        granted, error in
        if error != nil {
          self.showAlert("Error requesting for authorization.", withTitle: "Registration Status")
        }
        print("Permission granted: \(granted)")
        guard granted else { return }
        self.getNotificationSettings()
      }
  }

  private func _handleUnregister() {
    let hub = getNotificationHub()
    hub.unregisterNative { error in
      if error != nil {
        self.showAlert("Error unregistering for push: \(error.debugDescription)", withTitle: "Registration Status")
      } else {
        self.showAlert("Unregistered", withTitle: "Registration Status")
      }
    }
  }

  //
  // AppDelegate events
  //
  public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let unparsedTags = tags
    let tagsArray = unparsedTags.split(separator: ",")

    let hub = getNotificationHub()
    hub.registerNative(withDeviceToken: deviceToken, tags: Set(tagsArray)) {
      error in
      if error != nil {
        self.showAlert("Error registering for notifications: \(error.debugDescription)", withTitle: "Registration Status")
      } else {
        self.showAlert("Registered", withTitle: "Registration Status")
      }
    }
  }
  
  public func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register: \(error)")
    self.showAlert("Registration failed with \(error)", withTitle: "Registration Status")
  }

  /*
   static func application(_: UIApplication,
                           didFailToRegisterForRemoteNotificationsWithError error: Error) {
     print("Failed to register: \(error)")
   }
   */
  
   public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
    print("Received remote (silent) notification")

    showAlert("Received remote (silent) notification", withTitle: "Notification")

    completionHandler(UIBackgroundFetchResult.newData)
    
    return true
  }
  
  public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                     willPresent notification: UNNotification,
                                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("Received notification while the application is in the foreground")

    showNotification(notification.request.content.userInfo as! [String: Any])

    completionHandler([.sound, .badge])
  }

  public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                     didReceive response: UNNotificationResponse,
                                     withCompletionHandler completionHandler: @escaping () -> Void) {
    print("Received notification while the application is in the background")

    showNotification(response.notification.request.content.userInfo as! [String: Any])

    completionHandler()
  }

  //
  // App logic and helpers
  //
  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      print("Notification settings: \(settings)")
      guard settings.authorizationStatus == .authorized else { return }
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }

  func getNotificationHub() -> SBNotificationHub {
    return SBNotificationHub(connectionString: NHInfoConnectionString, notificationHubPath: NHInfoHubName)
  }

  func showAlert(_ message: String, withTitle title: String = "Alert") {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
  }

  func showNotification(_ userInfo: [String: Any]) {
    var title: String?
    var body: String?

    let aps = userInfo["aps"] as? [String: Any]
    let alertObject = aps?["alert"]
    if alertObject != nil {
      if let alertDict = alertObject as? [String: Any] {
        title = alertDict["title"] as? String
        body = alertDict["body"] as? String
      } else if let alertStr = alertObject as? String {
        body = alertStr
      } else {
        print("Unable to parse notification content. Unexpected format: \(String(describing: alertObject))")
      }
    }

    if title == nil {
      title = "<unset>"
    }

    if body == nil {
      body = "<unset>"
    }

    showAlert(body ?? "<unset>", withTitle: title ?? "<unset>")
  }
}
