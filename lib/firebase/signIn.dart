import 'package:campus_subsystem/faculty/faculty_dashboard.dart';
import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../redux/actions/fetchUserData.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? _userFromCredUser(User? user) {
    return user;
  }

  // String? getMail(User? user) {
  //   return user?.email;
  // }

  Stream<User?> get user {
    return auth.authStateChanges().map(_userFromCredUser);
  }

  Future signIn({
    required String username,
    required String password,
    required dynamic context,
    required bool isStudent,
    required dynamic click,
  }) async {
    try {
      final UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);
      //we got user

      print("hererrrrrrrrrrrrr 789");
      User? user = await result.user;

      print("hererrrrrrrrrrrrr 456");
      await fetchUserData(result.user?.email);
      if(isStudent){
        // await fetchUserData(result.user?.email);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentDashboard()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FacultyDashboard()));
      }

      print("hererrrrrrrrrrrrr 123");
      return _userFromCredUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid Email Address.")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Incorrect Password.")));
      } else if (e.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Check Internet Connection.")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.code.toString())));
      }
    }finally{
      click();
    }
  }

  Future<Stream?> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      return null;
    }
    return null;
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
