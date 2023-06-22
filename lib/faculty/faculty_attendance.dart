import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FacultyAttendance extends StatefulWidget {
  final Map<String, dynamic> references;
  final String date;

  final String subject;

  const FacultyAttendance({Key? key, required this.subject, required this.date, required this.references}) : super(key: key);

  @override
  State<FacultyAttendance> createState() => _FacultyAttendanceState();
}

class _FacultyAttendanceState extends State<FacultyAttendance> {
  Map<String, dynamic> rolls = {};
  Map<String, dynamic> rollmark = {};
  bool clicked = false;
  FirebaseFirestore inst = FirebaseFirestore.instance;

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

  Future<List> getStudentList() async {
    DocumentSnapshot rolllist = await inst.doc("College/${widget.references['branch']}/${widget.references['year']}/Roll_No").get();
    // await widget.references[1].get();
    List t = [];
    rolls = (rolllist.data() as Map<String, dynamic>);

    for (var element in rolls.keys) {
      t.add(int.parse(element));
    }
    t.sort();
    DocumentSnapshot prev = await inst
        .doc("College/${widget.references['branch']}/${widget.references['year']}/Attendance")
        .collection(widget.subject)
        .doc(widget.date)
        .get();
    if (prev.exists) {
      rollmark = prev.data() as Map<String, dynamic>;
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getStudentList(),
        builder: (context, AsyncSnapshot rollattend) {
          if (rollattend.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red)));
          } else {
            if (rollattend.hasData) {
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
                    String key = rollattend.data[index].toString();
                    return Container(
                      margin: const EdgeInsetsDirectional.only(start: 15, top: 20, end: 15),
                      alignment: Alignment.center,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadiusDirectional.only(
                              topStart: Radius.circular(50), topEnd: Radius.circular(50), bottomStart: Radius.circular(50)),
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
                floatingActionButton: clicked
                    ? FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: Colors.indigo[200],
                        // foregroundColor: Colors.black,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        )),
                      )
                    : FloatingActionButton.extended(
                        elevation: 1,
                        backgroundColor: Colors.indigo[200],
                        foregroundColor: Colors.black,
                        onPressed: () async {
                          clicked = true;
                          rollmark["time"] = DateFormat('dd-MM-yyyy-hh-mm').parse(widget.date);
                          // mark attendance of whole class
                          inst
                              .doc("College/${widget.references['branch']}/${widget.references['year']}/Attendance")
                              .collection(widget.subject)
                              .doc(widget.date)
                              .set(rollmark, SetOptions(merge: true))
                              .then((value) {
                            // mark attendance of each student
                            rolls.forEach((key, value) {
                              value
                                  .collection("Attendance")
                                  .doc(widget.subject)
                                  .set(<String, bool>{widget.date: rollmark[key]!}, SetOptions(merge: true));
                            });
                            clicked = false;
                            // back to dash
                            Navigator.pop(context);
                          });
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Submit",
                          style: TextStyle(fontFamily: 'MuliBold', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
              );
            } else {
              return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red)));
            }
          }
        });
  }
}
