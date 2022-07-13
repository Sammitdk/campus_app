import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StudentSubAttendance extends StatefulWidget {
  final String sub;

  final String name;
  const StudentSubAttendance({Key? key, required this.sub, required this.name}) : super(key: key);

  @override
  State<StudentSubAttendance> createState() => _StudentSubAttendanceState();
}

class _StudentSubAttendanceState extends State<StudentSubAttendance> {
  Map<String, dynamic> attendance = {};
  var sorted;
  Stream<Map<String, dynamic>> allattend() async* {
    DocumentReference dr = FirebaseFirestore.instance.doc(widget.sub);
    DocumentSnapshot ds = await dr.get();
    attendance = ds.data() as Map<String, dynamic>;
    sorted = attendance.keys.toList();
    sorted.sort();
    sorted = sorted.reversed;
    yield attendance;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future(() {
        setState(() {});
      }),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[300],
          centerTitle: true,
          title: Text(widget.name,style: const TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
        ),
        body: StreamBuilder(
          stream: allattend(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              Map attendance = snapshot.data as Map<String, dynamic>;
              if (attendance.isEmpty) {
                return const Center(
                    child: Text(
                  'Records Not Added.',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    String key = sorted.elementAt(index);
                    return Padding(
                      padding: const EdgeInsetsDirectional.all(20),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(bottom: 10),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Icon(
                                      Icons.subject_sharp,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    color: Colors.blue[100],
                                    child: Container(
                                      height: 80,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                  DateFormat(
                                                          'dd  MMM  yyyy hh:mm')
                                                      .format(DateFormat(
                                                              'dd-MM-yyyy-hh-mm')
                                                          .parse(key)),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'Custom'),
                                                  textAlign: TextAlign.center)),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                                attendance[key]
                                                    ? '  Present'
                                                    : '  Absent',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: attendance[key]
                                                        ? Colors.green[800]
                                                        : Colors.red)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      size: 50, color: Colors.red));
            }
          },
        ),
      ),
    );
  }
}
