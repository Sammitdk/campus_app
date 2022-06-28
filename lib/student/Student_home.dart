import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';

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
                    Text("  Hey ${widget.info['Name']['First']}",style: const TextStyle(fontSize: 30,fontFamily: 'Custom'),)
                  ]
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/timetable.gif",)),
                          const Expanded(flex: 1,child: Text(textAlign: TextAlign.center,"Time Table",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    )
                ),
                Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/syllabus.gif",),),
                          const Expanded(flex: 1,child: Text("Syllabus",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child:Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Column(
                      children: [
                        Expanded(flex: 4,child: Image.asset("assets/images/attendance.gif",)),
                        const Expanded(flex: 1,child: Text("Attendance",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Column(
                      children: [
                        Expanded(flex: 4,child: Image.asset("assets/images/notes.gif",),),
                        const Expanded(flex: 1,child: Text("Notes",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/events.gif",)),
                          const Expanded(flex: 1,child: Text("Events",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    )
                ),
                Expanded(
                    child: InkWell(
                      onTap: () async {
                        const url ='http://www.unishivaji.ac.in/exam/Online-Results';
                        if(await canLaunchUrlString(url)){
                          await launchUrlString(url);
                        }else {
                          throw 'Could not launch $url';
                        }
                    },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Column(
                          children: [
                            Expanded(flex: 4,child: Image.asset("assets/images/result.gif",)),
                            const Expanded(flex: 1,child: Text("Result",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                          ],
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
