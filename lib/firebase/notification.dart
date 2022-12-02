import 'dart:convert';

import 'package:campus_subsystem/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../redux/actions/fetchUserData.dart';
import '../redux/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(
    home: Scaffold(
      body: Noti(),
    ),
  ));
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

  static Future postNotification({
    int id = 0,
    required String title,
    required String message,
  }) async {
    String? a = await FirebaseMessaging.instance.getToken();
    print(a);
    // _noti.show(id, title, message, notificationDetails, payload: "GG");
    await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAA2wiUVMg:APA91bEENP3sWlqNpFgCMRGsoiFuaqybUVWFJGtc9PzK_XTjXMikwD1moeFzDnKxAvY2wkCPaNTYf2gELn6rfMXRL0qNT-40NqT1t4-vMsySvUjKdb2ZSecHxD3wqrCwS31uDQ8-Xq3Z',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': message,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': "evZNxjUJTOGgfLQvgrRVJT:APA91bHTIxjEEjzcKKxH9LOMa8TpO8PDgBVQRNPq1hhqgC2qjmhTdDias3S1k5QWWhNOVak4q321OrR_z38xpcQsb8eVZdR9-pgB4bTN9SbUZwSdGw6nklanSKgwXKV30a8wDUHrcQlX",
          },
        )
    );
  }
}

class Noti extends StatefulWidget {
  const Noti({Key? key}) : super(key: key);

  @override
  State<Noti> createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();
  //   var initializationSettingsAndroid = const AndroidInitializationSettings(
  //       'app_icon'); // <- default icon name is @mipmap/ic_launcher
  //   var initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        onPressed: () async {
          print("Click");
          // await NotificationAPI.postNotification(
          //   title: "Ayega",
          //   message: "He himmat",
          // );

          await FirebaseFirestore.instance.collection('Student_Detail').where('Email',isEqualTo: "sammitkhade80@gmail.com").get().then((value) async{
            if(value.docs.isNotEmpty){
              // store.dispatch(FetchData(
              //     email: email,
              //     prn: value.docs[0]['PRN'],
              //     roll_No: value.docs[0]['Roll_No'],
              //     address: value.docs[0]['Address'],
              //     sem: value.docs[0]['Sem'],
              //     mobile: value.docs[0]['Mobile'][0],
              //     year: value.docs[0]['Year'],
              //     dob: value.docs[0]['DOB'],
              //     name: value.docs[0]['Name'],
              //     isStudent: true,
              //     branch: value.docs[0]["Branch"],
              //     imgUrl: value.docs[0]['imgUrl']));
              print(value.docs[0]['PRN']);
            } else {
              // final DocumentReference facultyRef = ;
              await FirebaseFirestore.instance
                  .doc('Faculty_Detail/sammitkhade80@gmail.com').get().then((value) async {
                  Map<String,dynamic>  dtaa = value.data() as Map<String,dynamic>;
                print(dtaa);
                // final data = value.data() as Map<String, dynamic>;
                // store.dispatch(FetchData(
                //     email: value.id,
                //     prn: value['PRN'],
                //     roll_No: value['Roll_No'],
                //     isStudent: false));
              });
            }
          });
          // Map<String,dynamic> m = userRef.docs as Map<String,dynamic>;
          //todo
        },
        child: Text("+"),
      ),
    );
  }
}
