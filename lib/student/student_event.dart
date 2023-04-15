import 'package:flutter/material.dart';
import '../components/Event.dart';

class StudentEvent extends StatefulWidget {
  const StudentEvent({Key? key}) : super(key: key);

  @override
  State<StudentEvent> createState() => _StudentEventState();
}

class _StudentEventState extends State<StudentEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Event",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
        backgroundColor: Colors.indigo[300],
      ),
      body: Event(),
    );
  }
}
