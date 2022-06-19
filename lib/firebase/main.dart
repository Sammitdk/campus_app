import 'package:campus_subsystem/faculty_login.dart';
import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:campus_subsystem/login_page.dart';
import 'package:campus_subsystem/student_login.dart';
import 'package:flutter/material.dart';

import '../loading_page.dart';

void main() => runApp(
  Main()
);

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Wrapper(),
      initialRoute: 'loading_page',
      routes: {
        '/' :(context) => const Wrapper(),
        'loading_page':(context) => const LoadingPage(),
        'login_page': (context) => const Login(),
        't_login_form': (context) => const FacultyLogin(),
        's_login_form': (context) => const StudentLogin(),

      },
    );
  }
}
