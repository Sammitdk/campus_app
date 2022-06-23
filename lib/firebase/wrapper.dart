import 'package:campus_subsystem/firebase/signIn.dart';
import 'package:campus_subsystem/firebase/test.dart';
import 'package:campus_subsystem/student/student_profile.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // for testing the sign in method
    dynamic user = Auth.signIn(
      username: '2019087344',
      password: 'RAJV25012002'
    );
    return Container(
      child: StudentProfile(prn: '2019087344')
    );
  }
}
