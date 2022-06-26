import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getData(widget.prn);
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentDashboard(info: info)));
  }

  @override
  Widget build(BuildContext context) {
    return Text('data');
  }
}
