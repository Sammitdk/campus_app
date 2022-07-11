import 'package:campus_subsystem/student/student_sub_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StudentAttendance extends StatefulWidget {
  Map<String, dynamic> info;

  StudentAttendance({Key? key, required this.info}) : super(key: key);

  @override
  State<StudentAttendance> createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  Map<String, dynamic> attendance = {};
  Map<String, dynamic> subject = {};

  Stream<Map<String, dynamic>> getAttendance() async* {
    final DocumentReference subjects = FirebaseFirestore.instance.doc(
        '/College/${widget.info['Branch']}/${widget.info['Year']}/Subjects');
    DocumentSnapshot subjectsnapshot = await subjects.get();
    subject = subjectsnapshot.data() as Map<String, dynamic>;
    final CollectionReference studentdetail = FirebaseFirestore.instance
        .collection('/Student_Detail/${widget.info['PRN']}/Attendance');

    await subject[widget.info['Sem']].forEach((key, value) async {
      DocumentSnapshot sub = await studentdetail.doc(key).get();
      Map<String, dynamic> list = sub.data() as Map<String, dynamic>;
      attendance[value] = list;
    });
    await Future.delayed(const Duration(milliseconds: 350));
    yield attendance;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getAttendance(),
      builder: (context,AsyncSnapshot<Map<String,dynamic>> snap){
        if(snap.hasData){
          Map attendance = snap.data as Map<String,dynamic >;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Attendance",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
              backgroundColor: Colors.indigo[300],
            ),
            body: Padding(
              padding: const EdgeInsetsDirectional.all(20),
              child: ListView.builder(
                itemCount: attendance.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = attendance.keys.elementAt(index);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 10),
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
                                padding: const EdgeInsets.only(top: 15.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudentSubAttendance(sub: '/Student_Detail/${widget.info['PRN']}/Attendance/${subject[widget.info['Sem']].keys.firstWhere((element) => subject[widget.info['Sem']][element]==key)}')));
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 100,
                                            decoration:  BoxDecoration(
                                                borderRadius:
                                                const BorderRadiusDirectional.only(
                                                    topStart: Radius.circular(50),
                                                    topEnd: Radius.circular(50),
                                                    bottomStart: Radius.circular(50)),
                                                color: Colors.blue[100]),
                                            child: Text(key,
                                                style: const TextStyle(
                                                    fontSize: 20),
                                                textAlign: TextAlign.center),
                                          )),
                                      const SizedBox(width: 20,),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 100,
                                              decoration:  BoxDecoration(
                                                  borderRadius:
                                                  const BorderRadiusDirectional.only(
                                                    topStart: Radius.circular(50),
                                                    topEnd: Radius.circular(50),
                                                    bottomEnd: Radius.circular(50),),
                                                  color: Colors.blue[100]),
                                              child: Text(
                                                '${attendance[key].entries.where((e) => e.value == true).toList().length.toString()}/${attendance[key].length}',
                                              )
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          );
          // return Container();
        }else{
          return Center(child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red));
        }
      }
    );
    // return Container();
  }
}
