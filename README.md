# Introduction 
[Azure Notification Hubs] provide an easy-to-use and scaled-out push engine that allows you to send notifications to any platform (iOS, Android, Windows, Kindle, Baidu, etc.) from any backend (cloud or on-premises). Push notifications is a form of app-to-user communication where users of mobile apps are notified of certain desired information, usually in a pop-up or dialog box on a mobile device.

This plugin allows [Flutter] developers to extend their apps with Azure Notification Hub functionality. For this plugin to work, one must setup a Notification Hub within [Azure] and add the necessary capabilities within the project.

Currently, this plugin **only functions for iOS**. Android support is planned.

# Getting started
## Installation
To install this plugin, add azure_notification_hubs as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

## Setup a Notification Hub
Refer to https://docs.microsoft.com/en-us/azure/notification-hubs/notification-hubs-ios-push-notifications-swift-apps-get-started to create your own Azure Notification Hub.

## Add capabilities in your project
In XCode, find your target's *Signing & Capabilities* tab. Add *Push Notifications* and *Background Modes*. Additionally, in the Background Modes capability, check *Background fetch* and *Remote notifications*.

## Usage
- Instantiate the `AzureNotificationHubs`
- Call the instance's `init` function, passing your:
  - Connection String
  - Notification Hub Name
  - Tags to subscribe to (separated by commas)
- Call the instance's `register` function to subscribe to the previously passed tags.
- Send a Push Notification (e.g. Test Send in the [Azure] Portal) and receive it on your device
- Optional: Call the instance's `unregister` function to unsubscribe from all tags.

**Push Notifications only work on a physical device, the simulator will not suffice!**

# Example
To run the example, first clone the repo
```
git clone https://github.com/Sally-Assistant/azure_notification_hubs.git
```
Then you must set the `NHInfoConnectionString` and `NHInfoHubName` according to the data in your Notification Hub.
- `NHInfoHubName` is the name of your Notification Hub.
- `NHInfoConnectionString` should be in the following format: 
```
Endpoint=sb://<namespace>.servicebus.windows.net/;SharedAccessKeyName=<notificationHubKeyName>;SharedAccessKey=<notificationHubKey>
```
Finally, execute the following inside the example directory:
```
flutter run
```
You should be able to enter custom tags to register to upon which the app asks you for permission. You can then test send notifications to the device.

**Push Notifications only work on a physical device, the simulator will not suffice!**

# Contribute
- Propose any feature or enhancement
- Report a bug
- Open a pull request

[Azure Notification Hubs]: https://docs.microsoft.com/en-us/azure/notification-hubs/notification-hubs-push-notification-overview
[Flutter]: https://flutter.dev/
[Azure]: https://portal.azure.com/
