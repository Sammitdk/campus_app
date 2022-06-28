import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {
  final Map<String, dynamic> info;
  final FirebaseAuth auth = FirebaseAuth.instance;
  StudentProfile({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Image.asset("assets/images/profile.gif")
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.lightBlueAccent[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Icon(Icons.person),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${info['Name']['First']}", style: const TextStyle(fontSize: 30,fontFamily:'Narrow',),),
                            Text("${info['Name']['First']} ${info['Name']['Middle']} ${info['Name']['Last']}", style: const TextStyle(fontSize: 20,fontFamily:'Narrow',),),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0,top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.mail),Text(" : ${info['Email']}",style: const TextStyle(fontSize: 20,fontFamily:'Narrow',)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.cake),Text(" : ${info['DOB']}",style: const TextStyle(fontSize: 20,fontFamily:'Narrow',)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.call),Text(" : ${info['Mobile'][0]}",style: const TextStyle(fontSize: 20,fontFamily:'Narrow',)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () async => await auth.signOut(), label: const Text('LogOut'),icon: const Icon(Icons.logout),backgroundColor: Colors.white,foregroundColor: Colors.black,),
    );
  }
}