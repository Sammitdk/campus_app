import 'package:campus_subsystem/faculty/faculty_login.dart';
import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:campus_subsystem/login_page.dart';
import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:campus_subsystem/student/student_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';

import '../loading_page.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);
  runApp(
      const Main()
  );
}

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
        't_login_form': (context) => const KeyboardVisibilityProvider(child: FacultyLogin()),
        's_login_form': (context) => const KeyboardVisibilityProvider(child: StudentLogin()),
        'student_dashboard' : (context) => const StudentDashboard(),
      },
    );
  }
}
