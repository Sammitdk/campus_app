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
  final String prn;
  const StudentLoadingtoAttendance({Key? key,required this.prn}) : super(key: key);

  @override
  State<StudentLoadingtoAttendance> createState() => _StudentLoadingtoAttendanceState();
}

class _StudentLoadingtoAttendanceState extends State<StudentLoadingtoAttendance> {


  static Map<String,dynamic> attendance = {};
  final DocumentReference subjects = FirebaseFirestore.instance.doc('/College/CSE/TY/Subjects');
  // late DocumentSnapshot sub;

  Future<void> getAttendance() async{
    DocumentSnapshot subjectsnapshot = await subjects.get();
    Map<String,dynamic> subject = subjectsnapshot.data() as Map<String,dynamic>;
    final CollectionReference studentdetail = FirebaseFirestore.instance.collection('/Student_Detail/${widget.prn}/Attendance');
    await subject['6'].forEach((key,value) async{
      DocumentSnapshot sub = await studentdetail.doc(key).get();
      Map<String,dynamic> list = sub.data() as Map<String,dynamic>;
      // print('$list aaaaaaaaaaaaaaa');
      attendance[value] = list;
      // print(attendance);
    });
  }

  @override
  void initState() {
    // print('$attendance ssssssssssssssssss');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      getAttendance().then((_) {
        // print('$attendance ssssssssssssssssss');

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => StudentAttendance(attendance: attendance)));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return loading();
  }
}
