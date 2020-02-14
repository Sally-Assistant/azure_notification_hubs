import 'dart:async';

import 'package:flutter/services.dart';

class AzureNotificationHubs {
  static const MethodChannel _channel =
      const MethodChannel('azure_notification_hubs');

  static AzureNotificationHubs _sallyNotificationHubSingleton;

  factory AzureNotificationHubs() {
    if (_sallyNotificationHubSingleton == null) {
      _sallyNotificationHubSingleton = new AzureNotificationHubs._internal();
    }
    return _sallyNotificationHubSingleton;
  }

  //
  // Constructors
  //
  AzureNotificationHubs._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  //
  // Public Functions
  //
  Future getPlatformVersion() async {
    print("AzureNotificationHubs: getPlatformVersion called");
    var result = await _channel.invokeMethod('getPlatformVersion');
    print(result);
  }

  Future init(
      String infoConnectionString, String infoHubName, String tags) async {
    print("AzureNotificationHubs: init called");
    await _channel
        .invokeMethod('init', [infoConnectionString, infoHubName, tags]);
  }

  Future register() async {
    print("AzureNotificationHubs: register called");
    await _channel.invokeMethod('register');
  }

  Future unregister() async {
    print("AzureNotificationHubs: unregister called");
    await _channel.invokeMethod('unregister');
  }

  //
  // Private Functions
  //
  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      default:
        print('Unknown method ${call.method}');
    }
  }
}
