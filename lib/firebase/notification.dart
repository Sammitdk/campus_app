import "dart:convert";

import "package:campus_subsystem/firebase_options.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:http/http.dart" as http;

import "../redux/actions/fetchUserData.dart";
import "../redux/store.dart";


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message ${message.toMap()}");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // String? token = await FirebaseMessaging.instance.getToken();
  // print(token);
  FirebaseMessaging.onMessageOpenedApp.listen((event) {print(" aaaaaaaaaaaaaaaaa"+event.data.toString());});
  FirebaseMessaging.onMessage.listen((event) {
    Map data = event.toMap();
    NotificationAPI.postLocalNotification(title: "local"+data["notification"]['title'], message: data["notification"]['body']);
    print("     sfgsefseef" + data["notification"]['route'].toString());
  });
  runApp(const MaterialApp(
    home: Scaffold(
      body: Noti(),
    ),
  ));
}




class NotificationAPI {
  // static final _noti = FlutterLocalNotificationsPlugin();

  static final _noti = FlutterLocalNotificationsPlugin();

  static NotificationDetails? get notificationDetails =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "id",
          "name",
          channelDescription: 'desc',
          importance: Importance.max,
        ),
      );

  static Future postLocalNotification({
    int id = 0,
    required String title,
    required String message,
  }) async {
    _noti.show(id, title, message, notificationDetails, payload: "assets/logo.jpg");
  }
  static Future postNotification({
    int id = 0,
    required String title,
    required String message,
    required String receiver,
  }) async {
    await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization":
              "key=${DefaultFirebaseOptions.messegingkey}",
        },
        body: jsonEncode(
          <String, dynamic>{
            "notification": <String, dynamic>{
              "body": "Your God",
              "title": "the message from universe"
            },
            "priority": "high",
            "data": <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": "1",
              "status": "done",
              "route": "kahape"
            },
            "to": receiver,
          },
        ));
  }
}

class Noti extends StatefulWidget {
  const Noti({Key? key}) : super(key: key);

  @override
  State<Noti> createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterLocalNotificationsPlugin().initialize(const InitializationSettings(
      android: AndroidInitializationSettings(
          "app_icon"),
    ));

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if(event!=null){
        print("wwwwwwwwwwwwwwwwwwwwwwwwwwww${event.data.toString()}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        onPressed: () async {
          print("Click");
          await NotificationAPI.postNotification(
            title: "Ayega",
            message: "He himmat",
            receiver: "${await FirebaseMessaging.instance.getToken()}",
          );
          // Map<String,dynamic> m = userRef.docs as Map<String,dynamic>;
          //todo
        },
        child: Text("+"),
      ),
    );
  }
}
