import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentAttendance extends StatefulWidget {
   Map<String,dynamic> info;

  StudentAttendance({Key? key,required this.info}) : super(key: key);

  @override
  State<StudentAttendance> createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {

  Map<String,dynamic> attendance = {};

  Future<Map<String,dynamic>> getAttendance() async{
    final DocumentReference subjects = FirebaseFirestore.instance.doc('/College/${widget.info['Branch']}/${widget.info['Year']}/Subjects');
    DocumentSnapshot subjectsnapshot = await subjects.get();
    Map<String,dynamic> subject = subjectsnapshot.data() as Map<String,dynamic>;
    final CollectionReference studentdetail = FirebaseFirestore.instance.collection('/Student_Detail/${widget.info['PRN']}/Attendance');
    await subject['6'].forEach((key,value) async{
      DocumentSnapshot sub = await studentdetail.doc(key).get();
      Map<String,dynamic> list = sub.data() as Map<String,dynamic>;
      attendance[value] = list;
    });
    await Future.delayed(const Duration(milliseconds: 400));
    return attendance;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,dynamic>>(
      future: getAttendance(),
      builder: (context,AsyncSnapshot attendance){
        if(attendance.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(value: 1,backgroundColor: Colors.transparent,));
        }else{
          if(attendance.hasError){return Text(attendance.error.toString());}
          else{
            print(attendance.data.toString());
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
              ),
              body: ListView.builder(
                itemCount: attendance.data.length,
                itemBuilder: (BuildContext context,int index) {
                  String key = attendance.data.keys.elementAt(index);
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.subject_sharp,
                              size: 40,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                // alignment: Alignment.center,
                                height: 100,
                                // width: 300,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.only(
                                        topStart: Radius.circular(50),
                                        topEnd: Radius.circular(50),
                                        bottomEnd: Radius.circular(50),
                                        bottomStart: Radius.circular(50)),
                                    color: Colors.limeAccent
                                ),
                                child: Row(
                                  children: [
                                    Expanded(flex: 4,child: Text(key,style: const TextStyle(fontSize: 20,fontFamily: 'Custom'),textAlign: TextAlign.center)),
                                    Expanded(child: Text(attendance.data[key].entries.where((e) => e.value == true).toList().length.toString(),))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            );
          }
        }
      },
    );
    // return Container();
  }
}
