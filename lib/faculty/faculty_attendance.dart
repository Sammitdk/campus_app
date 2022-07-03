import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultyAttendance extends StatefulWidget {
  const FacultyAttendance({Key? key}) : super(key: key);

  @override
  State<FacultyAttendance> createState() => _FacultyAttendanceState();
}

class _FacultyAttendanceState extends State<FacultyAttendance> {
  final DocumentReference roll = FirebaseFirestore.instance.doc('College/CSE/TY/Roll_No');
  Map<String,dynamic> rolls = {};
  Map<String,bool> rollattend = {};
  Future markAttendance() async {

  }
  Future<Map<String,dynamic>> getStudentList()async{
    DocumentSnapshot rolllist = await roll.get();
    rolls = rolllist.data() as Map<String,dynamic>;
    rolls.forEach((key, value) {
      rollattend[key] = false;
    });
    return rolls;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStudentList(),
      builder: (context,AsyncSnapshot rolls){
        if(rolls.connectionState == ConnectionState.waiting){
          return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: CircularProgressIndicator(
                    value: 3,
                  )));
        }else{
          return Scaffold(
            body: ListView.builder(
            itemCount: rolls.data.length,
            itemBuilder: (BuildContext context,int index){
              return Checkbox(value: rollattend[rolls.data[index]], onChanged: (value){
                rollattend[rolls.data[index]] = !value!;
              });
            }),
          );
        }
      }
    );
  }
}
