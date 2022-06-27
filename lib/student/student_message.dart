import 'package:flutter/material.dart';

class StudentMessage extends StatelessWidget {
  final Map<String,dynamic> info;
  const StudentMessage({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(20),
      child: Column(
        children: [
          Expanded(
            flex: 3,
              child:  Text("  Hey ${info['Name']['First']}",style: const TextStyle(fontSize: 30,fontFamily: 'Custom'),)),
          const Expanded(
            flex: 4,
              child: Text(""))
        ],
      ),
    );
  }
}
