import 'package:campus_subsystem/student/student_profile.dart';
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
    const domain = '@dyp.com';
    try
    {
      final UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: username+domain, password: password);
      //we got user
      User? user = result.user;

      //we getting document for this user


      return _userFromCredUser(user);
    } catch (e)
    {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async
  {
   try
   {
     return await auth.signOut();
   }
   catch(e)
   {
     print(e.toString());
     return null;
   }
  }
}
// class Auth {
//
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   get user => Auth();
//
//   static Future signIn({required String username, required String password}) async{
//     const domain = '@dyp.com';
//     try{
//       final UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: username+domain, password: password);
//       final User? user = result.user;
//       // print(user);
//       return user;
//     } catch (e){
//       // return e;
//       print(e.toString());
//     }
//     // return 'Incorrect ID or Password';
//   }
// }