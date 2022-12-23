import 'package:campus_subsystem/password_reset.dart';
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
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Auth auth = Auth();
  bool isVisible = false;
  bool isClicked = false;

  void unClick() {
    setState(() {
      isClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
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
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 20),
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
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 20),
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
                          child: isClicked ? const Center(child: CircularProgressIndicator(),) : ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                foregroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.black),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                              child: const Text(
                                'Log In',
                                style: TextStyle(fontSize: 17),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isClicked = true;
                                  });
                                  await auth.signIn(
                                      username: emailController.text,
                                      password: passwordController.text,
                                      context: context,
                                      isStudent: true,
                                    click : unClick
                                  )
                                  ;
                                }
                              })),
                      Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                foregroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.black),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const ResetPassword()));
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
