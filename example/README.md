# azure_notification_hubs_example

To run the example, first clone the repo
```
git clone https://github.com/benediktdreher/azure_notification_hubs.git
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
