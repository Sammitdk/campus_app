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
    print('${widget.attendance} asasaassasa');
    return ListView.builder(
      itemCount: widget.attendance.length,
      itemBuilder: (BuildContext context,int index) {
        String key = widget.attendance.keys.elementAt(index);
        return Column(
          children: [
            Card(
              child: Text(key),
            )
          ],
        );
      },
    );
    // return Container();
  }
}
