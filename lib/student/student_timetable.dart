import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentTimeTable extends StatefulWidget {
  Map<String,dynamic> timetable;

  StudentTimeTable({Key? key,required this.timetable}) : super(key: key);

  @override
  State<StudentTimeTable> createState() => _StudentTimeTableState();
}

class _StudentTimeTableState extends State<StudentTimeTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      body: widget.timetable[DateFormat('EEEE').format(DateTime.now())] == null? Image.asset('assets/images/holiday.gif') : ListView.builder(
        itemCount: widget.timetable[DateFormat('EEEE').format(DateTime.now())].length,
        itemBuilder: (BuildContext context,int index) {
          String key = widget.timetable[DateFormat('EEEE').format(DateTime.now())].keys.elementAt(index);
          return Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.subject_sharp,
                      size: 40,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        // alignment: Alignment.center,
                        height: 100,
                        // width: 300,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(50),
                                topEnd: Radius.circular(50),
                                bottomEnd: Radius.circular(50),
                                bottomStart: Radius.circular(50)),
                            color: Colors.limeAccent
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 4,child: Text(key,style: const TextStyle(fontSize: 20,fontFamily: 'Custom'),textAlign: TextAlign.center)),
                            Expanded(child: Text(widget.timetable[DateFormat('EEEE').format(DateTime.now())][DateFormat('hh-mm').parse(key)]))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
    // return Container();
  }
}
