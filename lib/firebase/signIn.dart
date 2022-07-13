import 'package:firebase_auth/firebase_auth.dart';

class Auth
{
  final FirebaseAuth auth = FirebaseAuth.instance;


  User? _userFromCredUser(User? user) {
    return user;
  }

  Stream<User?> get user {
    return auth.authStateChanges().map(_userFromCredUser);
  }

  Future signIn({required String username, required String password}) async
  {
    try
    {
      final UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password);
      //we got user
      User? user = result.user;

      //we getting document for this user


      return _userFromCredUser(user);
    } catch (e)
    {
      return null;
    }
  }

  Future<Stream?> signOut() async
  {
   try
   {
      await auth.signOut();
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