import 'package:flutter/material.dart';

class FacultyLogin extends StatefulWidget {
  const FacultyLogin({Key? key}) : super(key: key);
  @override
  State<FacultyLogin> createState() => _FacultyLoginState();
}

class _FacultyLoginState extends State<FacultyLogin> {
  static String faculty = "faculty";
  static int a = 1;
  static const String _title = 'Log In';
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            title: const Text(_title,style: TextStyle(
              fontSize: 25,
              fontFamily: 'Custom'
            ),)
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Faculty',
                      style: TextStyle(fontSize: 20,fontFamily: 'Custom'),
                    )),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: nameController,
                          validator: (name) {
                            if(name == null || name.isEmpty){
                              return 'Enter ID';
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'ID',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          obscureText: true,
                          validator: (pswd){
                            if(pswd == null || pswd.isEmpty){
                              return 'Enter Password';
                            }
                          },
                          controller: passwordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: const Text('Login'),
                            onPressed: () {
                              if(formkey.currentState!.validate()){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logging In')));
                                print("${passwordController.text} = ${nameController.text}  ");
                              }
                              setState(
                                      (){

                                  }
                              );
                            },
                          )
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),

    );
  }
}
