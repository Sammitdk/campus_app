import 'package:campus_subsystem/student/student_attendance.dart';
import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


Widget loading() => Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      children: [
        Expanded(
            flex: 3,
            child: Image.asset("assets/images/load_student.gif")),
        Expanded(
            flex: 1,
            child: Image.asset("assets/images/load.gif")),
      ],
    ));


class StudentLoading extends StatefulWidget {
  final String email;

  const StudentLoading({Key? key, required this.email}) : super(key: key);

  @override
  State<StudentLoading> createState() => _StudentLoadingState();
}

class _StudentLoadingState extends State<StudentLoading> {
  Map<String, dynamic> info = {};
  final CollectionReference cr =
      FirebaseFirestore.instance.collection('Emails');

  Future<void> getData(String email) async {
    DocumentSnapshot qs = await cr.doc(email).get();
    info = qs.data() as Map<String, dynamic>;
    // QuerySnapshot qss =
    qs = await info["PRN"].get();
    info = qs.data() as Map<String, dynamic>;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getData(widget.email);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentDashboard(info: info)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }
}


// StudentLoadingtoAttendance


class StudentLoadingtoAttendance extends StatefulWidget {
  const StudentLoadingtoAttendance({Key? key}) : super(key: key);

  @override
  State<StudentLoadingtoAttendance> createState() => _StudentLoadingtoAttendanceState();
}

class _StudentLoadingtoAttendanceState extends State<StudentLoadingtoAttendance> {


  Map<String,dynamic> attendance = {};
  late DocumentReference subjects;
  late CollectionReference studentdetail;
  late DocumentSnapshot sub;

  Future<void> fillAttendance() async{
    subjects = FirebaseFirestore.instance.doc('/College/CSE/TY/Subjects');
    studentdetail = FirebaseFirestore.instance.collection('/Student_Detail/2019087340/Attendance');
    DocumentSnapshot subsnapshot = await subjects.get();
    final subject = subsnapshot.data() as Map<String,dynamic>;
    await subject['6'].forEach((key,value) async{
      sub = await studentdetail.doc(key).get();
      Map<String,dynamic> list = sub.data() as Map<String,dynamic>;
      attendance[value] = list;
      // print(attendance);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await fillAttendance();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentAttendance(attendance: attendance)));
    });
  }
  @override
  Widget build(BuildContext context) {
    return loading();
  }
}
