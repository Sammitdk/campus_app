import 'package:campus_subsystem/firebase/test.dart';
import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_subsystem/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  // final CollectionReference student = FirebaseFirestore.instance.collection('Student_Info');
  // student.add({'l':'patil'}).;
  // AuthService.signInAnon();
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Test(),
    );
  }
}


class AuthService {

  static final FirebaseAuth auth = FirebaseAuth.instance;

  // sign in anon
  static Future signInAnon() async {
    try {
      UserCredential result = await auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign in with email and password


// register with email and password

// sign out

}
