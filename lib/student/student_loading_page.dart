import 'package:campus_subsystem/student/student_attendance.dart';
import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:campus_subsystem/student/student_syllabus.dart';
import 'package:campus_subsystem/student/student_timetable.dart';
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentDashboard(info: info)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }
}



class StudentLoadingtoAttendance extends StatefulWidget {
  final Map<String,dynamic> info;
  StudentLoadingtoAttendance({Key? key,required this.info}) : super(key: key);

  @override
  State<StudentLoadingtoAttendance> createState() => _StudentLoadingtoAttendanceState();
}

class _StudentLoadingtoAttendanceState extends State<StudentLoadingtoAttendance> {


  Map<String,dynamic> attendance = {};

  Future<void> getAttendance() async{
    final DocumentReference subjects = FirebaseFirestore.instance.doc('/College/${widget.info['Branch']}/${widget.info['Year']}/Subjects');
    DocumentSnapshot subjectsnapshot = await subjects.get();
    Map<String,dynamic> subject = subjectsnapshot.data() as Map<String,dynamic>;
    final CollectionReference studentdetail = FirebaseFirestore.instance.collection('/Student_Detail/${widget.info['PRN']}/Attendance');
    subject['6'].forEach((key,value) async{
      DocumentSnapshot sub = await studentdetail.doc(key).get();
      Map<String,dynamic> list = sub.data() as Map<String,dynamic>;
      attendance[value] = list;
    });
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAttendance();
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentAttendance(attendance: attendance,)));
    });
  }
  @override
  Widget build(BuildContext context) {
    return loading();
  }
}


class StudentLoadingToSyllabus extends StatefulWidget {
  final Map<String,dynamic> info;

  const StudentLoadingToSyllabus({Key? key, required this.info}) : super(key: key);
  @override
  State<StudentLoadingToSyllabus> createState() => _StudentLoadingToSyllabusState();
}

class _StudentLoadingToSyllabusState extends State<StudentLoadingToSyllabus> {
  late  Map<String,dynamic> subject = {};
  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getSyllabus();
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentSyllabus(subject: subject,)));
    });
  }
  Future<void> getSyllabus()async {
    DocumentReference subjects = FirebaseFirestore.instance.doc('/College/${widget.info['Branch']}/${widget.info['Year']}/Subjects');
    DocumentSnapshot syllabusSnapshot = await subjects.get();
    subject = syllabusSnapshot.data() as Map<String, dynamic>;
  }
  @override
  Widget build(BuildContext context) {
    return loading();
  }
}

class StudentLoadingtoTimetable extends StatefulWidget {
  final Map<String,dynamic> info;

  const StudentLoadingtoTimetable({Key? key,required this.info}) : super(key: key);

  @override
  State<StudentLoadingtoTimetable> createState() => _StudentLoadingtoTimetableState();
}

class _StudentLoadingtoTimetableState extends State<StudentLoadingtoTimetable> {
  Map<String,dynamic> timetable = {};
  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getSyllabus();
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentTimeTable(timetable: timetable,)));
    });
  }
  Future<void> getSyllabus()async {
    DocumentReference subjects = FirebaseFirestore.instance.doc('/College/${widget.info['Branch']}/${widget.info['Year']}/Timetable');
    DocumentSnapshot timetableSnapshot = await subjects.get();
    timetable = timetableSnapshot.data() as Map<String, dynamic>;
  }
  @override
  Widget build(BuildContext context) {
    return loading();
  }
}
