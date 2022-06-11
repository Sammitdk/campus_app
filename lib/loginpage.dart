import 'dart:ffi';

import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  static String faculty = "faculty";
  static int a=1;
  // Widget RadioButtons => ;

  Widget studentLogin() => Column(
    children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(30,20,30,20),
        child: TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.numbers),
            label: Text("PRN Number"),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(30,20,30,20),
        child: TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.password),
            label: Text("Password"),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      FloatingActionButton(onPressed: (){},
        child: Text("Sign In"),backgroundColor: Colors.blue[400],hoverColor: Colors.green,shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),),
    ],
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
        [

          SizedBox(height: 450,),
          Row(
            children: [
              Container(
                width: 195,
                height: 230,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/student_login.gif",
                      ),
                      Text("Student")
                    ],
                  ),
                ),
              ),
              Container(
                width: 195,
                height: 230,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/teacher_login.gif",
                        repeat: ImageRepeat.repeat,
                      ),
                      Text("Faculty")
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}