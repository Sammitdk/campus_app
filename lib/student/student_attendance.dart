import 'package:campus_subsystem/redux/reducer.dart';
import 'package:campus_subsystem/student/student_sub_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StudentAttendance extends StatelessWidget {
  List subjectlist = [];
  StudentAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<AppState>(context).state;

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .doc("College/${state.branch}/${state.year}/Subjects")
          .get(),
      builder: (BuildContext context, AsyncSnapshot list) {
        if (list.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    size: 50, color: Colors.red)),
          );
        } else {
          subjectlist = list.data.data()[state.sem].values.toList();
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Attendance",
                style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.indigo[300],
            ),
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Student_Detail/${state.prn}/Attendance")
                    .snapshots(),
                builder: (context, AsyncSnapshot attendance) {
                  if (attendance.hasData && attendance.data.docs.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.all(20),
                      child: ListView.builder(
                        itemCount: attendance.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (subjectlist
                              .contains(attendance.data.docs[index].id)) {
                            return Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(bottom: 10),
                              child: Row(
                                children: [
                                  const Expanded(
                                    flex: 1,
                                    child: Icon(
                                      Icons.subject_sharp,
                                      size: 40,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 20, end: 20, top: 30),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      StudentSubAttendance(
                                                        subject: attendance.data
                                                            .docs[index].id,
                                                      )));
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child: Card(
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(50),
                                                              topLeft: Radius
                                                                  .circular(50),
                                                              topRight: Radius
                                                                  .circular(
                                                                      50))),
                                                  elevation: 5,
                                                  color: Colors.blue[100],
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadiusDirectional
                                                                .only(
                                                            topStart:
                                                                Radius.circular(
                                                                    50),
                                                            topEnd:
                                                                Radius.circular(
                                                                    50),
                                                            bottomStart:
                                                                Radius.circular(
                                                                    50)),
                                                        color:
                                                            Colors.blue[100]),
                                                    child: Text(
                                                        attendance.data
                                                            .docs[index].id,
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Card(
                                                  elevation: 5,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          50),
                                                              topLeft: Radius
                                                                  .circular(50),
                                                              topRight: Radius
                                                                  .circular(
                                                                      50))),
                                                  color: Colors.blue[100],
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 100,
                                                      child: Text(
                                                        '${attendance.data.docs[index].data().entries.where((e) => e.value == true).toList().length.toString()}/${attendance.data.docs[index].data().length}',
                                                      )),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  } else {
                    return Container(
                      color: Colors.white,
                      child: Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                              size: 50, color: Colors.red)),
                    );
                  }
                }),
          );
        }
      },
    );
  }
}
