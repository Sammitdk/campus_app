import 'package:campus_subsystem/faculty/faculty_dashboard.dart';
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
    )
);



class DataLoading extends StatefulWidget {
  final String email;

  const DataLoading({Key? key, required this.email}) : super(key: key);

  @override
  State<DataLoading> createState() => _DataLoadingState();
}

class _DataLoadingState extends State<DataLoading> {
  Map<String, dynamic> info = {};
  late bool exist;

  Future<void> getData(String? email) async {
    final DocumentReference studentref =
    FirebaseFirestore.instance.doc('Email/$email');
    print('$email ddddddddddddddd');
    info = await studentref.get().then((value) async {
      exist = value.exists;
      if(value.exists) {
        info = value.data() as Map<String, dynamic>;
        value = await info["PRN"].get();
        return value.data() as Map<String, dynamic>;
      }else{
          return await FirebaseFirestore.instance.doc('Faculty_Detail/$email').get().then((value) => value.data() as Map<String, dynamic>);
      }
    });
}
class StudentLoading extends StatefulWidget {
  final String? email;

  const StudentLoading({Key? key, required this.email}) : super(key: key);

  @override
  State<StudentLoading> createState() => _StudentLoadingState();
}

class _StudentLoadingState extends State<StudentLoading> {

  Map<String, dynamic> info = {};
  final CollectionReference cr =
  FirebaseFirestore.instance.collection('Email');

  Future<void> getData(String? email) async {
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
      if(exist) {
        // print('object $exist');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentDashboard(info: info)));
      }else{
        // print('object $exist');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => FacultyDashboard(info: info)));
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentDashboard(info: info)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }
}

