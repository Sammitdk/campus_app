import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth
{
  final FirebaseAuth auth = FirebaseAuth.instance;


  User? _userFromCredUser(User? user) {
    return user;
  }

  String? getMail(User? user){
    return user?.email;
  }


  Stream<User?> get user {
    return auth.authStateChanges().map(_userFromCredUser);
  }



  Future signIn({required String username, required String password , required dynamic context}) async
  {
    try
    {
      final UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password);
      //we got user
      User? user = result.user;
      return _userFromCredUser(user);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  Future<Stream?> signOut() async
  {
   try
   {
      await FirebaseAuth.instance.signOut();
   }
   catch(e)
   {
     return null;
   }
   return null;
  }
  Future resetPassword(email) async{
    try{
      await auth.sendPasswordResetEmail(email: email);
      return true;
    }on FirebaseException {
      return false;
    }
  }
}