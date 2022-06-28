import 'package:flutter/material.dart';

class StudentMessage extends StatelessWidget {
  final Map<String,dynamic> info;
  const StudentMessage({Key? key, required this.info}) : super(key: key);

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
