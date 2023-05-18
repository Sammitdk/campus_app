import 'package:campus_subsystem/faculty/faculty_dashboard.dart';
import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../redux/actions/fetchUserData.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? _user;
  // bool isLogged = false;

  // User? _userFromCredUser(User? user) {
  //   return user;
  // }

  User? getUser() {
    return _user;
  }

  Auth() {
    auth.authStateChanges().listen((user) {
      print("aaaaaaaaaaaa  $user");
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn({
    required String username,
    required String password,
    required bool isStudent,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password).then((result) async {
        _user = result.user;
        // isLogged = true;
        print(result.user);
        await FetchData().fetchUserData(result.user!.email);
        // Provider.of<Auth>(context, listen: false)._user = result.user;
        notifyListeners();
      });
      //we got user

      // if (isStudent) {
      //   // await fetchUserData(result.user?.email);
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //           builder: (_) => StudentDashboard(
      //                 email: username,
      //               )));
      // } else {
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //           builder: (_) => FacultyDashboard(email: username)));
      // }
      notifyListeners();
      // return _userFromCredUser(user);
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut().then((_) {
        _user = null;
        notifyListeners();
      });
    } catch (e) {
      print(e);
      // return null;
    }
    // return null;
  }

  Future resetPassword(email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseException {
      return false;
    }
  }
}
