import 'package:campus_subsystem/redux/reducer.dart';
import 'package:campus_subsystem/student/student_sub_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StudentAttendance extends StatefulWidget {
  Map<String, dynamic> info = {};
  StudentAttendance({Key? key}) : super(key: key);

  @override
  State<StudentAttendance> createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  // Map<String, dynamic> attendance = {};
  Map<String, dynamic> subject = {};
  List sorted = [];
  var state;



  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<AppState>(context).state;


    Stream<Map<String, dynamic>> getAttendance() async* {
      // final DocumentReference subjects = FirebaseFirestore.instance.doc(
      //     '/College/${state.branch}/${state.year}/Subjects');
      // DocumentSnapshot subjectsnapshot = await subjects.get();
      // subject = subjectsnapshot.data() as Map<String, dynamic>;
      // final CollectionReference studentdetail = FirebaseFirestore.instance
      //     .collection('/Student_Detail/${state.prn}/Attendance');
      
      FirebaseFirestore.instance.collection("Student_Detail/${state.prn}/Attendance").get().then((value){
        value.docs.forEach((element) {print("FFFFFFFFFFF${element.data()}");});
      });
      
      // sorted = subject[state.sem].keys.toList();
      // sorted.sort();
      // sorted.forEach((key) async {
      // DocumentSnapshot sub = await studentdetail.doc(key).get();
      // Map<String, dynamic> list = sub.data() as Map<String, dynamic>;
      // attendance[subject[state.sem][key]] = list;
      // });
      await Future.delayed(const Duration(seconds: 1));
      // yield attendance;
    }
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Student_Detail/${state.prn}/Attendance").snapshots(),
      builder: (context,AsyncSnapshot attendance){
        if(attendance.hasData){
          // Map attendance = snap.data as Map<String,dynamic >;

          print("qqqqqqqqqqqqqqqqqqqqqqq${attendance.data.docs[0].data()}");
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Attendance",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
              backgroundColor: Colors.indigo[300],
            ),
            body: Padding(
              padding: const EdgeInsetsDirectional.all(20),
              child: ListView.builder(
                itemCount: attendance.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  // String key = sorted.elementAt(index);
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
                                padding:  const EdgeInsetsDirectional.only(start: 20,end: 20,top: 30),
                                child: InkWell(
                                  onTap: (){
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudentSubAttendance()));
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Card(
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),topLeft: Radius.circular(50),topRight: Radius.circular(50))),
                                            elevation: 5,
                                            color: Colors.blue[100],
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
                                              child: Text(attendance.data.docs[index].id,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                  textAlign: TextAlign.center),
                                            ),
                                          )),
                                      const SizedBox(width: 20,),
                                      Expanded(
                                          flex: 1,
                                          child: Card(
                                            elevation: 5,
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),topLeft: Radius.circular(50),topRight: Radius.circular(50))),
                                            color: Colors.blue[100],
                                            child: Container(
                                                alignment: Alignment.center,
                                                height: 100,
                                                child: Text(
                                                  '${attendance.data.docs[index].data().entries.where((e) => e.value == true).toList().length.toString()}/${attendance.data.docs[index].data().length}',
                                                )
                                            ),
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
        }else{
          return Container(
            color: Colors.white,
            child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red)),
          );
        }
      }
    );
  }
}
