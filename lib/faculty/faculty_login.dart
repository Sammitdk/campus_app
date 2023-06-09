import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import '../firebase/auth.dart';
import '../password_reset.dart';

class FacultyLogin extends StatefulWidget {
  const FacultyLogin({Key? key}) : super(key: key);

  @override
  State<FacultyLogin> createState() => _FacultyLoginState();
}

class _FacultyLoginState extends State<FacultyLogin> {
  static const String _title = 'Log In';
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isVisible = false;
  bool isClicked = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
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
                      isClicked
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
                                setState(() => isClicked = true);
                                if (formKey.currentState!.validate()) {
                                  await Auth()
                                      .signIn(
                                    username: emailController.text.trim(),
                                    password: passwordController.text,
                                    isStudent: false,
                                  )
                                      .onError((FirebaseException e, stackTrace) async {
                                   
                                    if (e.code == 'user-not-found') {
                                      return await Auth()
                                          .createUser(
                                        username: emailController.text.trim(),
                                        password: passwordController.text,
                                        isStudent: false,
                                      )
                                          .onError((FirebaseException error, stackTrace) {
                                       
                                        return null;
                                      }).then((value) => true);
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(const SnackBar(content: Text("Invalid Email Address.")));
                                    } else if (e.code == 'wrong-password') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(content: Text("Incorrect 4 Password.")));
                                    } else if (e.code == 'network-request-failed') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(content: Text("Check Internet Connection.")));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
                                    }
                                    return null;
                                  }).then((value) {
                                    if (value != null && value) {
                                      Navigator.of(context).pop();
                                    } else {
                                      if (value != null && !value) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text(
                                          "Don't use Student Login in Faculty section.",
                                          maxLines: 2,
                                        )));
                                      }
                                    }
                                  });
                                }
                                setState(() => isClicked = false);
                              },
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton.extended(
                        label: const Text(
                          'Forgot Password',
                          // style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                        heroTag: null,
                        backgroundColor: Colors.indigo[300],
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPassword()));
                        },
                      ),
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
