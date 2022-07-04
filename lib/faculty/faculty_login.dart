import 'package:campus_subsystem/faculty/faculty_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lottie/lottie.dart';
import '../firebase/signIn.dart';
import '../firebase/wrapper.dart';
import '../student/student_reset.dart';

class FacultyLogin extends StatefulWidget {
  const FacultyLogin({Key? key}) : super(key: key);
  @override
  State<FacultyLogin> createState() => _FacultyLoginState();
}

class _FacultyLoginState extends State<FacultyLogin> {
  static const String _title = 'Log In';
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Auth auth = Auth();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(_title),
        backgroundColor: Colors.indigo[300],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              isKeyboardVisible ?  SizedBox(
                child: Lottie.network("https://assets1.lottiefiles.com/temp/lf20_vKPgdY.json"),
              ) : Container(
                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/icons/teacher_login.gif",
                    ),
                  ],
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Faculty',
                    style: TextStyle(fontSize: 30,fontFamily: 'Custom'),
                  )
              ),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 40,right: 40,bottom: 20),
                      child: TextFormField(
                        controller: emailController,
                        validator: (name) {
                          if(name == null || name.isEmpty){
                            return 'Enter Email Address';
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),  //Email TextField
                    Container(
                      padding: const EdgeInsets.only(left: 40,right: 40,bottom: 20),
                      child: TextFormField(
                        obscureText: !isVisible,
                        validator: (pswd){
                          if(pswd == null || pswd.isEmpty){
                            return 'Enter Password';
                          }
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            suffixIcon: IconButton(onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            }, icon: const Icon(Icons.remove_red_eye))
                        ),
                      ),
                    ),  //Password TextField
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                            foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),),
                          child: const Text('Log In',style: TextStyle(fontSize: 17),),
                          onPressed: () async {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FacultyDashboard()));
                            // if(formkey.currentState!.validate())
                            // {
                            //   if(await auth.signIn(username: emailController.text,password: passwordController.text) != null)
                            //   {
                            //      Navigator.of(this.context).pushReplacement(MaterialPageRoute(builder: (_) => const FacultyDashboard()));
                            //   }
                            //   else
                            //   {
                            //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect PRN or Password'),));
                            //   }
                            // }
                            // else
                            // {
                            //   setState(() {});
                            // }
                          },
                        )
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                              foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),),
                            child: const Text('Forgot Pass',style: TextStyle(fontSize: 17,color: Colors.black),),
                            onPressed: () async{ Navigator.push(context,MaterialPageRoute(builder: (_) => ResetPassword()));
                          },
                        ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
