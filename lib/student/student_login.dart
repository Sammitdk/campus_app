import 'package:campus_subsystem/student/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../firebase/signIn.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);
  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  static const String _title = 'Log In';
  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final scrrenheight = MediaQuery.of(context).size.height;
    final scrrenwidth = MediaQuery.of(context).size.width;
    final bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          title: const Text(_title),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                    children: <Widget>[
                      isKeyboardVisible ? const SizedBox(height: 100,) : Container(
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/student_login.gif",
                            ),
                          ],
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(20),
                          child: const Text(
                            'Student',
                            style: TextStyle(fontSize: 30,fontFamily: 'Custom'),
                          )),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 40,right: 40,bottom: 20),
                              child: TextFormField(
                                controller: nameController,
                                validator: (name) {
                                  if(name == null || name.isEmpty){
                                    return 'Enter Prn';
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Prn No',
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 40,right: 40,bottom: 20),
                              child: TextFormField(
                                obscureText: true,
                                validator: (pswd){
                                  if(pswd == null || pswd.isEmpty){
                                    return 'Enter Password';
                                  }
                                },
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                ),
                              ),
                            ),
                            Container(
                                height: 50,
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),),
                                  child: const Text('Sign In',style: TextStyle(fontSize: 17),),
                                  onPressed: () {
                                    if(formkey.currentState!.validate())
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logging In'),));

                                      // Delay not working :
                                      // process has to wait before going to next page
                                      // for authenticate user

                                      if(Auth.signIn(username: nameController.text,password: passwordController.text) != null){
                                        Future.delayed(Duration(seconds: 3));
                                        Navigator.of(this.context).pushReplacement(MaterialPageRoute(builder: (_) => StudentProfile(prn: nameController.text)));
                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect PRN or Password'),));
                                      }
                                    }else{
                                      setState(() {});
                                    }
                                  },
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
