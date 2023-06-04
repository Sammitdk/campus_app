import 'package:campus_subsystem/password_reset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import '../firebase/auth.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  static const String _title = 'Log In';
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isVisible = false;
  bool isClicked = false;

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                isKeyboardVisible
                    ? SizedBox(
                        width: 150,
                        child: Image.asset("assets/images/keyboardLoad.gif"),
                      )
                    : Container(
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
                      style: TextStyle(fontSize: 30, fontFamily: 'Custom'),
                    )),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                        child: TextFormField(
                          controller: emailController,
                          validator: (name) {
                            if (name == null || name.isEmpty) {
                              return 'Enter Email Address';
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ), //Email TextField
                      Container(
                        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                        child: TextFormField(
                          obscureText: !isVisible,
                          validator: (pswd) {
                            if (pswd == null || pswd.isEmpty) {
                              return 'Enter Password';
                            }
                            return null;
                          },
                          controller: passwordController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: const Icon(Icons.remove_red_eye))),
                        ),
                      ), //Password TextField
                      Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: isClicked
                              ? FloatingActionButton(
                                  heroTag: null,
                                  onPressed: null,
                                  backgroundColor: Colors.indigo[300],
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : FloatingActionButton.extended(
                                  heroTag: null,
                                  backgroundColor: Colors.indigo[300],
                                  label: const Text(
                                    'Log In',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() => isClicked = true);
                                      await Auth()
                                          .signIn(
                                        username: emailController.text.trim(),
                                        password: passwordController.text,
                                        isStudent: true,
                                      )
                                          .onError((FirebaseException e, stackTrace) async {
                                        print(e);
                                        if (e.code == 'user-not-found') {
                                          print("askalsad");
                                          return await Auth()
                                              .createUser(
                                            username: emailController.text.trim(),
                                            password: passwordController.text,
                                            isStudent: true,
                                          )
                                              .onError((FirebaseException error, stackTrace) {
                                            print("mmmmmmmm${error.code}");
                                            return null;
                                          }).then((value) => true);
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(const SnackBar(content: Text("Invalid Email Address.")));
                                        } else if (e.code == 'wrong-password') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(content: Text("Incorrect Password.")));
                                        } else if (e.code == 'network-request-failed') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(content: Text("Check Internet Connection.")));
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
                                        }
                                        return null;
                                        // return false;
                                      }).then((value) {
                                        if (value != null && value) {
                                          Navigator.of(context).pop();
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text(
                                            "Don't use Faculty Login in Student section.",
                                            maxLines: 2,
                                          )));
                                        }
                                      });
                                      setState(() => isClicked = false);
                                    }
                                  })),
                      Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5),
                                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.indigo.shade300),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              ),
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(fontSize: 17, color: Colors.white),
                              ),
                              onPressed: () async {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPassword()));
                              })),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
