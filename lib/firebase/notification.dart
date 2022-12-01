import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
      runApp(const MaterialApp(
        home: Scaffold(
          body: Noti(),
        ),
      ));
    }

class NotificationAPI{
  static final _noti = FlutterLocalNotificationsPlugin();

  static NotificationDetails? get notificationDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      "id",
      "name",
      channelDescription: 'desc',
      importance: Importance.max
    ),

  );



  static Future showNoti({int id = 0,String? title,String? message,}) async {
    _noti.show(id, title, message, notificationDetails,payload: "GG");
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
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon'); // <- default icon name is @mipmap/ic_launcher
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid,);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        onPressed: () async {
          print("Click");
          await NotificationAPI.showNoti(
            title: "Ayega",
            message: "He himmat",
          );
          //todo
        },
        child: Text("+"),
      ),
    );
  }
}
