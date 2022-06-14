import 'package:campus_subsystem/faculty_login.dart';
import 'package:campus_subsystem/student_login.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140,
        backgroundColor: Colors.white,
        title: Container(
          child: Image.asset("assets/images/welcome.gif"),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
        [
          Expanded(
            child: Container(
              width: double.infinity,
              height: 380,
              child: Image.asset("assets/images/logo.jpg",color: Colors.brown[500],),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: 195,
                    // height: 230,
                    child: InkWell(
                      onTap: ()
                      {
                        Navigator.push(context,  MaterialPageRoute(builder: (context) => const StudentLogin()));
                      },
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
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 195,
                    // height: 230,
                    child: InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FacultyLogin()),);
                      },
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
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}