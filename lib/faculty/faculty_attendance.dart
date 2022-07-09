import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultyAttendance extends StatefulWidget {
  final List<dynamic> subject;
  final String date;

  const FacultyAttendance({Key? key,required this.subject, required this.date}) : super(key: key);

  @override
  State<FacultyAttendance> createState() => _FacultyAttendanceState();
}

class _FacultyAttendanceState extends State<FacultyAttendance> {
  Map<String,dynamic> rolls = {};
  Map<String,bool> rollattend = {};
  Future markAttendance() async {
    // DocumentReference college = FirebaseFirestore.instance.doc('/College/${widget.branch}/${widget.year}/Attendance/Subjects/CC');
    DocumentSnapshot col = await widget.subject[0].get();
    Map<String,dynamic> previous = col.data() as Map<String,dynamic>;
    previous[widget.date] = rollattend;
    widget.subject[0].update(previous);
  }
  Future perStudentAttendance()async{
    rollattend.forEach((key, value) async {
      DocumentSnapshot ds = await rolls[key].get();
      Map<String,dynamic> info = ds.data() as Map<String,dynamic>;
      String PRN = info['PRN'];
      print(PRN);
      DocumentReference student = FirebaseFirestore.instance.doc('Student_Detail/${PRN}/${widget.subject[2]}');
      DocumentSnapshot stu = await student.get();
      Map<String,dynamic> previous = stu.data() as Map<String,dynamic>;
      print(previous);
      previous[widget.date] = value;
      student.update(previous);
    });
  }
  Future<Map<String,dynamic>> getStudentList()async{
    // final DocumentReference roll = FirebaseFirestore.instance.doc('College/${widget.branch}/${widget.year}/Roll_No');
    DocumentSnapshot rolllist = await widget.subject[1].get();
    rolls = rolllist.data() as Map<String,dynamic>;
    rolls.forEach((key, value) async {
      rollattend[key] = false;
    });
    await Future.delayed(const Duration(milliseconds: 350));
    return rollattend;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.subject);
    // return Container();
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
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: const Text("Attendance",style: TextStyle(fontFamily: 'MuliBold'),),
              backgroundColor: Colors.indigo[300],
            ),
            body: ListView.builder(
            itemCount: rollattend.data.length,
            itemBuilder: (BuildContext context,int index){
              return Container(
                margin: const EdgeInsetsDirectional.only(start: 15,top: 20,end: 15),
                alignment: Alignment.center,
                height: 70,
                decoration:  BoxDecoration(
                    borderRadius:
                    const BorderRadiusDirectional.only(
                        topStart: Radius.circular(50),
                        topEnd: Radius.circular(50),
                        bottomStart: Radius.circular(50)),
                    color: Colors.blue[50]),
                child: Center(
                  child: StatefulBuilder(
                    builder: (BuildContext context,setState) => CheckboxListTile(
                      activeColor: Colors.transparent,
                      checkColor: Colors.black,
                          title: Text(rollattend.data.keys.elementAt(index)),
                          value: rollattend.data[rollattend.data.keys.elementAt(index)],
                          secondary: const Icon(Icons.checklist_rtl_outlined),
                          onChanged:(_){
                            setState(() => rollattend.data[rollattend.data.keys.elementAt(index)] = !rollattend.data[rollattend.data.keys.elementAt(index)]);
                    },
                  ),
                ),
                ),
              );
            },
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 1,
              backgroundColor: Colors.indigo[200],
              foregroundColor: Colors.black,
              onPressed: () async{
                await markAttendance();
                await perStudentAttendance();
              },
              child: const Text("Submit",style: TextStyle(fontFamily: 'MuliBold'),),
            ),
          );
        }
      }
    );
  }
}

