import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentLoading extends StatefulWidget {
  final String prn;

  const StudentLoading({Key? key,required this.prn}) : super(key: key);

  @override
  State<StudentLoading> createState() => _StudentLoadingState();
}

class _StudentLoadingState extends State<StudentLoading> {
  Map<String,dynamic> info = {};
  final CollectionReference cr = FirebaseFirestore.instance.collection('Student_Detail');
  // final String prn;

  Future<void> getData(String prn) async
  {
    DocumentSnapshot qs = await cr.doc(prn).get();
    info = qs.data() as Map<String,dynamic>;
  }
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getData(widget.prn);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentDashboard(info: info)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      )
    );
  }
}
