import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../faculty/faculty_event_show.dart';

class StudentEvent extends StatefulWidget {
  StudentEvent({Key? key,required this.x}) : super(key: key);
  QueryDocumentSnapshot x;

  @override
  State<StudentEvent> createState() => _StudentEventState();
}

class _StudentEventState extends State<StudentEvent> {
  @override
  Widget build(BuildContext context) {
    return ShowEvent(x: widget.x,);
  }
}