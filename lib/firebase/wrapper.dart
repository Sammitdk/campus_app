import 'package:campus_subsystem/login_page.dart';
import 'package:campus_subsystem/student/student_loading_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final user = Provider.of<User?>(context);

    if(user == null){
        return const Login();
    }
    else{
        final email = user.email;
        if(email != null)
        {
          return StudentLoading(prn: email.replaceAll('@dyp.com', ''),);
        }
        else{
          return const Login();
        }
    }
  }
}
