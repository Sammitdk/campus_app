import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: StudentLogin(),
));


class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);
  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  static String faculty = "faculty";
  static int a = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 360,
            height: 500,
          ),
          SizedBox(height: 20,),
           Column(
             children: const [
               TextField(
                 decoration: InputDecoration(
                   icon: Icon(Icons.numbers),
                   label: Text("PRN Number"),
                   border: OutlineInputBorder(),
                 ),
               ),
             ],
           ),
          SizedBox(height: 20,),
          Column(
            children: const [
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.password),
                  label: Text("Password"),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Column(
            children: [
              FloatingActionButton(
                onPressed: () {},
                child: Text("Sign In"),
                backgroundColor: Colors.blue[400],
                hoverColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),),),
            ],
          ),
        ],
      ),
    );
  }
}

