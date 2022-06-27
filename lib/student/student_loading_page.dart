import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
    qs = await info["PRN"].get();
    info = qs.data() as Map<String, dynamic>;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getData(widget.email);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => StudentDashboard(info: info)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Lottie.network(
                    "https://assets8.lottiefiles.com/packages/lf20_i9mtrven.json")),
            Expanded(
                flex: 1,
                child: Lottie.network(
                    "https://assets6.lottiefiles.com/packages/lf20_pr1wd00z.json")),
          ],
        ));
  }
}