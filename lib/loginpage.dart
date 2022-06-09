import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: login(),
));
class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 15,top: 20),
                  child: Image.network("assets/images/logo.jpg",height: 100,),
                )
              ],
            ),
            const SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        Image.network("assets/icons/student_login.gif",),
                        Text("Student login",)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child:  Column(
                      children: [
                        Image.network("assets/icons/teacher_login.gif",),
                        Text("Faculty Login ")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
      ),
    );
  }
}
