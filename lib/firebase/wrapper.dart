import 'package:campus_subsystem/firebase/signIn.dart';
import 'package:campus_subsystem/firebase/test.dart';
import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:campus_subsystem/student/student_profile.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    dynamic user = Auth.signIn(username: '2019087344',password: 'RAJ25012002');
    return const StudentDashboard();
  }
}
