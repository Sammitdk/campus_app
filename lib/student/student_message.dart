import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

class StudentMessage extends StatelessWidget {
  final Map<String,dynamic> info;
  StudentMessage({Key? key, required this.info}) : super(key: key);
  final FirebaseMessaging obj = FirebaseMessaging.instance;
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async{
      print(await obj.getToken());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(20),
      child: ListView(
        children: [
          Column(
            children: [
              Text("Welcome ${info['Name']['First']}",style: const TextStyle(fontSize: 40,fontFamily: 'Custom'),),
            ]
          ),
        ]
      ),
    );
  }
}
