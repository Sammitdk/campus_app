import 'package:campus_subsystem/student/student_attendance.dart';
import 'package:campus_subsystem/student/student_loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StudentHome extends StatefulWidget {
  final Map<String,dynamic> info;
  const StudentHome({Key? key, required this.info}) : super(key: key);


  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(20),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child:
              Row(
                  children: [
                    Text("  Hey ${widget.info['Name']['First']}",
                      style: const TextStyle(
                          fontSize: 30, fontFamily: 'Custom'),)
                  ]
              ),
            ),
          ),  //Name Tag
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,
                              child: Image.asset(
                                "assets/images/timetable.gif",)),
                          const Expanded(
                              flex: 1, child: Text(
                            textAlign: TextAlign.center,
                            "Time Table",
                            style: TextStyle(
                                fontFamily: 'Custom', fontSize: 20),)),
                        ],
                      ),
                    )
                ),
                Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context,'s_syllabus');
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Column(
                          children: [
                            Expanded(flex: 4, child: Image.asset(
                              "assets/images/syllabus.gif",),),
                            const Expanded(flex: 1, child: Text("Syllabus",
                              style: TextStyle(
                                  fontFamily: 'Custom', fontSize: 20),)),
                          ],
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),  //TimeTable-Syllabus
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child:InkWell(
                    onTap: () async {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const StudentLoadingtoAttendance()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/attendance.gif",)),
                          const Expanded(flex: 1,child: Text("Attendance",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Column(
                      children: [
                        Expanded(flex: 4,
                            child: Image.asset(
                              "assets/images/attendance.gif",)),
                        const Expanded(
                            flex: 1, child: Text("Attendance", style: TextStyle(
                            fontFamily: 'Custom', fontSize: 20),)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Image.asset("assets/images/notes.gif",),),
                        const Expanded(
                            flex: 1, child: Text("Notes", style: TextStyle(
                            fontFamily: 'Custom', fontSize: 20),)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),  //Attendance-Notes
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,
                              child: Image.asset("assets/images/events.gif",)),
                          const Expanded(
                              flex: 1, child: Text("Events", style: TextStyle(
                              fontFamily: 'Custom', fontSize: 20),)),
                        ],
                      ),
                    )
                ),
                Expanded(
                    child: InkWell(
                      onTap: () async {
                        const url = 'https://14.139.121.222/studentresult/';
                        if (!await canLaunchUrlString(url)) {
                          await launchUrlString(
                            url,
                            mode: LaunchMode.externalNonBrowserApplication,
                            webViewConfiguration: const WebViewConfiguration(
                              enableDomStorage: true,
                              enableJavaScript: true,
                            ),
                          );
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Column(
                          children: [
                            Expanded(flex: 4, child: Image.asset(
                              "assets/images/result.gif",)),
                            const Expanded(flex: 1, child: Text("Result",
                              style: TextStyle(
                                  fontFamily: 'Custom', fontSize: 20),)),
                          ],
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),  //Events-Result
        ],
      ),
    );
  }
}