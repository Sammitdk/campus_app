import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultyAttendance extends StatefulWidget {
  final String branch;

  final String sem;

  final String year;

  FacultyAttendance({Key? key,required this.year,required this.sem,required this.branch}) : super(key: key);

  @override
  State<FacultyAttendance> createState() => _FacultyAttendanceState();
}

class _FacultyAttendanceState extends State<FacultyAttendance> {
  Map<String,dynamic> rolls = {};
  Map<String,bool> rollattend = {};
  Future markAttendance() async {
    DocumentReference college = FirebaseFirestore.instance.doc('/College/${widget.branch}/${widget.year}/Attendance/Subjects/CC');
    DocumentSnapshot col = await college.get();
    Map<String,dynamic> previous = col.data() as Map<String,dynamic>;
    previous['05-07-2022-09-00'] = rollattend;
    college.update(previous);
  }
  Future perStudentAttendance()async{
    rollattend.forEach((key, value) async {
      DocumentSnapshot ds = await rolls[key].get();
      Map<String,dynamic> info = ds.data() as Map<String,dynamic>;
      String PRN = info['PRN'];
      print(PRN);
      DocumentReference student = FirebaseFirestore.instance.doc('Student_Detail/${PRN}/Attendance/CC');
      DocumentSnapshot stu = await student.get();
      Map<String,dynamic> previous = stu.data() as Map<String,dynamic>;
      print(previous);
      previous['05-07-2022-09-00'] = value;
      student.update(previous);
    });
  }
  Future<Map<String,dynamic>> getStudentList()async{
    final DocumentReference roll = FirebaseFirestore.instance.doc('College/${widget.branch}/${widget.year}/Roll_No');
    DocumentSnapshot rolllist = await roll.get();
    rolls = rolllist.data() as Map<String,dynamic>;
    rolls.forEach((key, value) async {
      DocumentSnapshot studentname = await value.get();
      Map<String,dynamic> info = studentname.data() as Map<String,dynamic>;
      rollattend[key] = false;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    return rollattend;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStudentList(),
      builder: (context,AsyncSnapshot rollattend){
        if(rollattend.connectionState == ConnectionState.waiting){
          return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: CircularProgressIndicator(
                    value: 3,
                  )
              )
          );
        }else{
          return Scaffold(
            body: ListView.builder(
            itemCount: rollattend.data.length,
            itemBuilder: (BuildContext context,int index){
              return Center(
                child: StatefulBuilder(
                  builder: (BuildContext context,setState) => CheckboxListTile(
                        title: Text(rollattend.data.keys.elementAt(index)),
                        checkColor: Colors.black,
                        value: rollattend.data[rollattend.data.keys.elementAt(index)],
                        secondary: const Icon(Icons.check),
                        onChanged:(_){
                          setState(() => rollattend.data[rollattend.data.keys.elementAt(index)] = !rollattend.data[rollattend.data.keys.elementAt(index)]);
                  },
                ),
              ),
              );
            },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()async{
                await markAttendance();
                await perStudentAttendance();
              },
              child: const Text("OK"),
            ),
          );
        }
      }
    );
  }
}
