import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
        [
          Container(
            //flex: 2,
            child: Container(
              width: double.infinity,
              child: Image.asset("assets/images/welcome.gif",),
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
                        Navigator.pushNamed(context, 's_login_form');
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
                        Navigator.pushNamed(context, 't_login_form');
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
          ),
        ],
      ),
    );
  }
}