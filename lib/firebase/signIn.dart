import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static Future<User?> signIn({required String username, required String password}) async{
    const domain = '@dyp.com';
    try{
      final UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: username+domain, password: password);
      final User? user = result.user;
      return user;
    } catch (e){
      print(e.toString());
    }
    return null;
  }
}