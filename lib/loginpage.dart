import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
  ));
}


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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 230,
                child: InkWell(
                  onTap: ()
                  {
                    print("ok");
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.network(
                            "assets/icons/student_login.gif",
                          ),
                          Text("Student")
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 230,
                width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Image.network(
                        "assets/icons/teacher_login.gif",
                        repeat: ImageRepeat.repeat,
                      ),
                      Text("Faculty")
                    ],
                  ),
                ),
              ),
            ],
          ),
          studentLogin(),
        ],
      ),
    );
  }
}