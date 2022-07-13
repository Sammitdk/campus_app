import 'package:campus_subsystem/faculty/faculty_notes.dart';
import 'package:campus_subsystem/faculty/faculty_subject.dart';
import 'package:flutter/material.dart';

import 'faculty_attendance_option.dart';
import 'faculty_event.dart';

class FacultyHome extends StatefulWidget {
  Map<String,dynamic> info = {};
  FacultyHome({Key? key, required this.info}) : super(key: key);

  @override
  State<FacultyHome> createState() => _FacultyHomeState();
}

class _FacultyHomeState extends State<FacultyHome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(20),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Row(children: [
                Text("  Hey ${widget.info['Name']['First']}. ${widget.info['Name']['Middle']}. ${widget.info['Name']['Last']}",
                  style: const TextStyle(fontSize: 30, fontFamily: 'Custom'),
                )
              ]),
            ),
          ), //Name Tag
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Column(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Image.asset(
                                  "assets/images/timetable.gif",
                                )),
                            const Expanded(
                                flex: 1,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Time Table",
                                  style:
                                  TextStyle(fontFamily: 'Custom', fontSize: 20),
                                )),
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    child: InkWell(
                      onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => FacultySubject(info: widget.info)));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Image.asset(
                                "assets/images/syllabus.gif",
                              ),
                            ),
                            const Expanded(
                                flex: 1,
                                child: Text(
                                  "Subjects",
                                  style:
                                  TextStyle(fontFamily: 'Custom', fontSize: 20),
                                )),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ), //TimeTable-Syllabus
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){ Navigator.push(context,MaterialPageRoute(builder: (_) => FacultyAttendanceOption(info: widget.info)));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Image.asset(
                                "assets/images/attendance.gif",
                              )),
                          const Expanded(
                              flex: 1,
                              child: Text(
                                "Attendance",
                                style: TextStyle(
                                    fontFamily: 'Custom', fontSize: 20),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FacultyNotes()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Image.asset(
                              "assets/images/notes.gif",
                            ),
                          ),
                          const Expanded(
                              flex: 1,
                              child: Text(
                                "Notes",
                                style:
                                TextStyle(fontFamily: 'Custom', fontSize: 20),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ), //Attendance-Notes
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => FacultyEvent(info: widget.info,)));
                    },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Column(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Image.asset(
                                  "assets/images/events.gif",
                                )),
                            const Expanded(
                                flex: 1,
                                child: Text(
                                  "Events",
                                  style:
                                  TextStyle(fontFamily: 'Custom', fontSize: 20),
                                )),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ), //Events-Result
        ],
      ),
    );
  }
}
