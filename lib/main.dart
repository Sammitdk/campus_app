import 'package:campus_subsystem/faculty_login.dart';
import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:campus_subsystem/firebase_options.dart';
import 'package:campus_subsystem/login_page.dart';
import 'package:campus_subsystem/student_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'loading_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Wrapper(),
      initialRoute: '/',
      routes: {
        '/' :(context) => const Wrapper(),
        'loading_page':(context) => const LoadingPage(),
        'login_page': (context) => const Login(),
        't_login_form': (context) => const KeyboardVisibilityProvider(child: FacultyLogin()),
        's_login_form': (context) => const KeyboardVisibilityProvider(child: StudentLogin()),
      },
    );
  }
}
