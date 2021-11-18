import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/panda');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(onDidReceiveLocalNotification: (_, __, ___, ____) async {});
  final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (_) async {});
  runApp(MyApp(flutterLocalNotificationsPlugin));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp(this.noti);
  final FlutterLocalNotificationsPlugin noti;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(noti, title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.noti, {Key? key, required this.title}) : super(key: key);
  final String title;
  final FlutterLocalNotificationsPlugin noti;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    //FlutterAppBadger.isAppBadgeSupported().then((a) => a ? print("Yayyyyyyyy") : print("Fuck"));
    setState(() {
      _counter++;
    });
   // FlutterAppBadger.updateBadgeCount(_counter);
  }

  void _decrementCounter() {
    //FlutterAppBadger.isAppBadgeSupported().then((a) => a ? print("Yayyyyyyyy") : print("Fuck"));
    setState(() {
      if (_counter > 0) _counter--;
    });
    //FlutterAppBadger.updateBadgeCount(_counter);
  }

  void _showNoti() {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        Uuid().v4(), 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, showWhen: false);
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    widget.noti.show(Random().nextInt(10000), 'plain title', 'plain body', platformChannelSpecifics, payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have this many unseen notifications',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => Future.delayed(
              Duration(seconds: Platform.isIOS ? 3 : 0),
              _showNoti,
            ),
            tooltip: 'Show noti',
            child: Icon(Icons.notification_add),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: Icon(Icons.clear_outlined),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
