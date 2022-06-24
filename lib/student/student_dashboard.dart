import 'package:flutter/material.dart';

import '../firebase/signIn.dart';


class StudentDashboard extends StatelessWidget {
  StudentDashboard({Key? key}) : super(key: key);
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dashboard",),
        actions: [
        ],
      ),
      drawer: const Drawer(
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Card(
                          elevation: 5,
                          child: Image.asset("assets/images/timetable.gif")
                      ),
                      const Text("Time Table",style: TextStyle(fontFamily: 'Custom',fontSize: 20),),
                    ],
                  ),

                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Column(
                      children: [
                      Image.asset("assets/images/notes.gif",),
                      const Text("Notes",style: TextStyle(fontFamily: 'Custom',fontSize: 20),),
                      ],
                    ),
                  )
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Card(
                          elevation: 5,
                          child: Image.asset("assets/images/attendance.gif")
                      ),
                      const Text("Attendance",style: TextStyle(fontFamily: 'Custom',fontSize: 20),),
                    ],
                  ),
                ),
                const SizedBox(width: 30,),
                Expanded(
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Image.asset("assets/images/events.gif",),
                      ),
                      const Text("Events",style: TextStyle(fontFamily: 'Custom',fontSize: 20),),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Card(
                          elevation: 5,
                          child: Image.asset("assets/images/message.gif")
                      ),
                      const Text("Message",style: TextStyle(fontFamily: 'Custom',fontSize: 20),),
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Image.asset("assets/images/result.gif",),
                      ),
                      const Text("Result",style: TextStyle(fontFamily: 'Custom',fontSize: 20),),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 20),
              child: SizedBox(
                height: 50,
                width: 100,
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),),
                    child: const Text('Sign Out',style: TextStyle(fontFamily: 'Custom',),textAlign: TextAlign.center,),
                    onPressed: () async {
                      await auth.signOut();
                    }),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 40, 10),
      //   child: Container(
      //     height: 70,
      //     decoration: const BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.all(Radius.circular(40),),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.black26,
      //           blurRadius:10,
      //           offset: Offset(2, 2),
      //         )
      //       ]
      //     ),
      //     child: const Text("Sign Out",style: TextStyle(fontFamily: 'Custom',fontSize: 30),textAlign: TextAlign.center,),
      //   ),
      // ),
    );
  }
}
