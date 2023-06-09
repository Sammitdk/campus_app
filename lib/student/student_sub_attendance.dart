import 'package:campus_subsystem/redux/reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StudentSubAttendance extends StatelessWidget {
  final String subject;

  const StudentSubAttendance({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<AppState>(context).state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        centerTitle: true,
        title: Text(
          subject,
          style: const TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.doc("Student_Detail/${state.prn}/Attendance/$subject").snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map attendance = snapshot.data.data() as Map<String, dynamic>;
            if (attendance.isEmpty) {
              return const Center(
                  child: Text(
                'Records Not Added.',
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ));
            } else {
              return ListView.builder(
                itemCount: attendance.length,
                itemBuilder: (context, index) {
                  String key = attendance.keys.elementAt(index);
                  return Padding(
                    padding: const EdgeInsetsDirectional.all(20),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Container(
                                height: 80,
                                alignment: Alignment.center,
                                child: Text(DateFormat('dd  MMM  yyyy hh:mm').format(DateFormat('dd-MM-yyyy-hh-mm').parse(key)),
                                    style: const TextStyle(fontSize: 20, fontFamily: 'Custom'), textAlign: TextAlign.center),
                              )),
                          Expanded(
                            flex: 2,
                            child: Text(attendance[key] ? '  Present' : '  Absent',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: attendance[key] ? Colors.green[800] : Colors.red)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red));
          }
        },
      ),
    );
  }
}
