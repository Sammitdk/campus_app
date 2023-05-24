import 'package:campus_subsystem/faculty/faculty_dashboard.dart';
import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../redux/actions/fetchUserData.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? _user;
  final fetch = FetchData();

  User? getUser() {
    return _user;
  }

  Auth() {
    auth.authStateChanges().listen((user) async {
      print("aaaaaaaaaaaa  $user");
      // _isStudent = await fetch.getUserType(user?.email);
      _user = user;
      notifyListeners();
    });
  }
  Future<bool?> signIn({
    required String username,
    required String password,
    required bool isStudent,
  }) async {
    bool? success;
    try {
      success = await fetch.getUserType(username);
      print('eeeeeeeeeee $success $isStudent');
      if (success != null) {
        if (isStudent == success) {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: username, password: password)
              .then((UserCredential result) async {
            //we got user
            _user = result.user;
            // _isStudent = success;
            print(result.user);
            if (success!) {
              await fetch.fetchStudentData(username).onError((error, stackTrace) {
                print(" ooooooooooooooooo $error  $stackTrace");
                // return false;
              });
            } else {
              await fetch.fetchFacultyData(username).onError((error, stackTrace) {
                print(" iiiiiiiiiiiiiiiii $error  $stackTrace");
                // return false;
              });
            }
          });
        }
      }
      notifyListeners();
      return true;
      // return _userFromCredUser(user);
    } on FirebaseAuthException {
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
