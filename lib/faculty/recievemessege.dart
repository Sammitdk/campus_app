import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../message.dart';

class FacultyMessage extends StatefulWidget {
  const FacultyMessage({Key? key}) : super(key: key);
  static void rec() async{
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
  }

  @override
  State<FacultyMessage> createState() => _FacultyMessageState();
}

class _FacultyMessageState extends State<FacultyMessage> {
  // Firebase message = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Message.sendField(),
    );
  }
}
