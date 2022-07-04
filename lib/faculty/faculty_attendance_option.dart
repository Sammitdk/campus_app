 import 'package:campus_subsystem/faculty/faculty_attendance.dart';
import 'package:flutter/material.dart';

class FacultyAttendanceOption extends StatefulWidget {
  const FacultyAttendanceOption({Key? key}) : super(key: key);

  @override
  State<FacultyAttendanceOption> createState() => _FacultyAttendanceOptionState();
}

class _FacultyAttendanceOptionState extends State<FacultyAttendanceOption> {
  final branch = ["CSE",'CIVIL','MECH','ELE'];
  final year = ["SY",'TY','BE'];
  final sem = ['3','4','5','6','7','8'];
  String selctedbranch = 'CSE';
  String selectedsem = '6';
  String selectedyear = 'TY';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selctedbranch,
              items: branch.map<DropdownMenuItem<String>>((String br) => DropdownMenuItem<String>(value: br,child: Text(br))).toList(),
              onChanged: (newvalue){
                selctedbranch = newvalue!;
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedyear,
              items: year.map<DropdownMenuItem<String>>((String br) => DropdownMenuItem<String>(value: br,child: Text(br))).toList(),
              onChanged: (newvalue){
                selectedyear = newvalue!;
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedsem,
              items: sem.map<DropdownMenuItem<String>>((String br) => DropdownMenuItem<String>(value: br,child: Text(br))).toList(),
              onChanged: (newvalue){
                selectedsem = newvalue!;
              },
            ),
            ElevatedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FacultyAttendance(year: selectedyear,branch: selctedbranch,sem: selectedsem,))), child: const Text('Next'))
          ],
        ),
      ),
    );
  }
}
