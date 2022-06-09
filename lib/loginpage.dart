import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: login(),
  ));
}


class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  static String faculty = "faculty";
  static int a=1;
  // Widget RadioButtons => ;

  Widget studentLogin() => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(30,20,30,20),
        child: TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.numbers),
            label: Text("PRN Number"),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(30,20,30,20),
        child: TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.password),
            label: Text("Password"),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      Container(child: FloatingActionButton(onPressed: (){}, child: Text("Sign In")))
    ],
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Image.network(
                        "assets/icons/student_login.gif",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Student login",
                          style: TextStyle(
                            fontFamily: 'BubblegumSans',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 100,
                  // height: 100,
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.network(
                          "assets/icons/teacher_login.gif",
                          repeat: ImageRepeat.repeat,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Faculty Login"),
                        )
                      ],
                    ),
                  ),
                ),
<<<<<<< HEAD
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
=======
              ),
            ],
          ),
          studentLogin(),
        ],
>>>>>>> 8fe0d189722a823ed3a1ac600c427edf6f8fef3f
      ),
    );
  }
}
