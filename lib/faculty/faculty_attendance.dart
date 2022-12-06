import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FacultyAttendance extends StatefulWidget {
  final List references;
  final String date;

  final String subject;

  FacultyAttendance(
      {Key? key,
      required this.subject,
      required this.date,
      required this.references})
      : super(key: key);

  @override
  State<FacultyAttendance> createState() => _FacultyAttendanceState();
}

class _FacultyAttendanceState extends State<FacultyAttendance> {
  Map<String, dynamic> rolls = {};
  Map<String, dynamic> rollmark = {};
  // Future markAttendance() async {
  //   Map<String,dynamic> mark = {};
  //   mark[widget.date] = rollattend;
  //   widget.references[0].set(mark,SetOptions(merge: true));
  // }
  // Future perStudentAttendance()async{
  //   rollattend.forEach((key, value) async {
  //     DocumentSnapshot ds = await rolls[key].get();
  //     Map<String,dynamic> info = ds.data() as Map<String,dynamic>;
  //     String PRN = info['PRN'];
  //     CollectionReference student = FirebaseFirestore.instance.collection('Student_Detail/${PRN}/Attendance/Subjects/${widget.subject}');
  //     Map<String,dynamic> mark = {};
  //     mark[widget.date] = value;
  //     student.add(mark);
  //   });
  // }

  Future<Map<String,dynamic>> getStudentList() async {
    DocumentSnapshot rolllist = await widget.references[1].get();
    return rolllist.data() as Map<String,dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getStudentList(),
        builder: (context, AsyncSnapshot rollattend) {
          print("${rollattend.data}");
          if (rollattend.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        size: 50, color: Colors.red)));
          } else {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  "Attendance",
                  style: TextStyle(fontFamily: 'MuliBold'),
                ),
                backgroundColor: Colors.indigo[300],
              ),
              body: ListView.builder(
                itemCount: rollattend.data.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = rollattend.data.keys.elementAt(index);
                  return Container(
                    margin: const EdgeInsetsDirectional.only(
                        start: 15, top: 20, end: 15),
                    alignment: Alignment.center,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadiusDirectional.only(
                            topStart: Radius.circular(50),
                            topEnd: Radius.circular(50),
                            bottomStart: Radius.circular(50)),
                        color: Colors.blue[50]),
                    child: Center(
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return CheckboxListTile(
                            activeColor: Colors.transparent,
                            checkColor: Colors.black,
                            title: Text(key),
                            value: rollmark.containsKey(key) ? rollmark[key] : rollmark[key] = false,
                            secondary: const Icon(Icons.checklist_rtl_outlined),
                            onChanged: (value) {
                              setState(() => rollmark.containsKey(key) ? rollmark[key] = value! : rollmark[key] = true);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                elevation: 1,
                backgroundColor: Colors.indigo[200],
                foregroundColor: Colors.black,
                onPressed: () async {
                  rollmark["time"] = DateFormat(
                      'dd-MM-yyyy-hh-mm')
                    .parse(widget.date);
                  // mark attendance of whole class
                  widget.references[0].collection(widget.subject).doc(widget.date).set(
                    rollmark,SetOptions(merge: true)
                  );


                  // mark attendance of each student
                  rollattend.data.forEach((key,value) {
                    value.collection("Attendance").doc(widget.subject).set(<String,bool>{
                      widget.date : rollmark[key]!
                    },SetOptions(merge: true));
                  });

                  // back to dash
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.done_outline_rounded),
                label: const Text(
                  "Submit",
                  style: TextStyle(fontFamily: 'MuliBold'),
                ),
              ),
            );
          }
        });
  }
}
