import 'package:flutter/material.dart';

class StudentAttendance extends StatefulWidget {
   Map<String,dynamic> attendance;

  StudentAttendance({Key? key,required this.attendance}) : super(key: key);

  @override
  State<StudentAttendance> createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  @override
  Widget build(BuildContext context) {
    return Text('${widget.attendance}');
  }
}
