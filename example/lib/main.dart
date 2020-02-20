import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:azure_notification_hubs/azure_notification_hubs.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// TODO: Fill in your Azure Notification Hub information
const String NHInfoConnectionString = "TODO1";
const String NHInfoHubName = "TODO1";

const Color ORANGE = Color.fromARGB(255, 255, 127, 80);
const Color WHITE = Color.fromARGB(255, 255, 255, 255);
const Color RED = Color.fromARGB(255, 255, 0, 0);

class _MyAppState extends State<MyApp> {
  AzureNotificationHubs azure;
  TextEditingController tagController = new TextEditingController();
  bool valid;

  @override
  void initState() {
    super.initState();
    azure = new AzureNotificationHubs();
    valid = NHInfoConnectionString != "TODO" && NHInfoHubName != "TODO";
  }

  void init() {
    try {
      azure.init(NHInfoConnectionString, NHInfoHubName, tagController.text);
    } on PlatformException {}
  }

  void onPressRegister() {
    if (tagController.text == "") {
      print("Tags must not be empty!");
      return;
    }
    print("Registering for tags: ${tagController.text}");
    init();
    try {
      azure.register();
    } on PlatformException {}
  }

  void onPressUnRegister() {
    if (tagController.text == "") {
      print("Tags must not be empty!");
      return;
    }
    print("UnRegistering for tags: ${tagController.text}");
    init();
    try {
      azure.unregister();
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: ORANGE,
            title: const Text('Azure Notification Hubs Example App'),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NHInfoConnectionString == "TODO"
                    ? Text(
                        "Please set NHInfoConnectionString in example/main.dart",
                        style: TextStyle(color: RED, fontSize: 18),
                      )
                    : Container(),
                NHInfoHubName == "TODO"
                    ? Text(
                        "Please set NHInfoHubName in example/main.dart",
                        style: TextStyle(color: RED, fontSize: 18),
                      )
                    : Container(),
                TextField(
                  controller: tagController,
                  decoration: InputDecoration(
                      helperText: "Enter tags to (un-)register here",
                      hintText: "tag1,tag2,tag3,...",
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ORANGE))),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: valid ? onPressRegister : null,
                        color: ORANGE,
                        textColor: WHITE,
                        child: Text("Register")),
                    SizedBox(
                      width: 10,
                    ),
                    FlatButton(
                        onPressed: valid ? onPressRegister : null,
                        color: ORANGE,
                        textColor: WHITE,
                        child: Text("UnRegister"))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
