import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static Future signIn({required String username, required String password}) async{
    const domain = '@dyp.com';
    try{
      final UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: username+domain, password: password);
      final User? user = result.user;
      // print(user);
      return user;
    } catch (e){
      // return e;
      print(e.toString());
    }
    // return 'Incorrect ID or Password';
  }


}