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




class NotificationAPI {

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
    String? image,
  }) async {
    _noti.show(id, title, message, notificationDetails, payload: "chat_screen");
    // _noti.getNotificationAppLaunchDetails().asStream().listen((value){
    //   print(value?.didNotificationLaunchApp);
    //   // Navigator.of(context).pushNamed("chat_screen");
    // });
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
              "body": message,
              "title": title
            },
            "priority": "high",
            "data": <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": "1",
              "status": "done",
              "route": "chat_screen"
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
