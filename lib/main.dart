import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_subsystem/faculty/faculty_login.dart';
import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:campus_subsystem/login_page.dart';
import 'package:campus_subsystem/student/student_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase/signIn.dart';
import 'firebase_options.dart';
import 'loading_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(Main());
}

class Main extends StatelessWidget
{
  Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: Auth().user,
      initialData: null,
      child: MaterialApp(
        color: Colors.transparent,
        debugShowCheckedModeBanner: false,
        // home: Wrapper(),
        initialRoute: 'loading_page',
        routes: {
          '/' :(context) =>  const Wrapper(),
          'loading_page':(context) => const LoadingPage(),
          'login_page': (context) => const Login(),
          't_login_form': (context) => const KeyboardVisibilityProvider(child: FacultyLogin()),
          's_login_form': (context) => const KeyboardVisibilityProvider(child: StudentLogin()),
        },
      ),
    );
  }
}
