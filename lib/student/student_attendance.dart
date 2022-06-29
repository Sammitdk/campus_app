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
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.attendance.length,
        itemBuilder: (BuildContext context,int index) {
          String key = widget.attendance.keys.elementAt(index);
          return Column(
            children: [
              Container(
                height: 100,
                child: Card(
                  child: Row(
                    children: [
                      Expanded(flex: 4,child: Text(key,style: const TextStyle(fontSize: 20,fontFamily: 'Custom'),)),
                      Expanded(child: Text(widget.attendance[key].entries.where((e) => e.value == true).toList().length.toString()))
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
    // return Container();
  }
}
