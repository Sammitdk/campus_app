import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../firebase/signIn.dart';


class StudentDashboard extends StatelessWidget {
  final String prn;
  StudentDashboard({Key? key,required this.prn}) : super(key: key);
  final Auth auth = Auth();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   actions: [
      //     // const Text("SignOut",style: TextStyle(height: 2,fontFamily:'Custom',fontSize: 15),),
      //     // IconButton(
      //     //   icon: const Icon(Icons.account_circle_rounded,size: 35,),
      //     //   onPressed: () async {
      //     //     await auth.signOut();
      //     //   },
      //     // ),
      //     TextButton.icon(
      //         onPressed: () async {
      //           await auth.signOut();
      //         },
      //         label: Text(prn),
      //         icon: const Icon(Icons.precision_manufacturing_outlined),
      //       style: ButtonStyle(
      //         backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
      //       )
      //     )
      //   ],
      //   title: const Text("Dashboard",style: TextStyle(fontSize: 23),),
      // ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20),
        child: Column(
          children: [
             Expanded(
              flex: 1,
                child: Center(
                    child:
                    Row(
                      children: const [
                      Text("   Hey Sammit",style: TextStyle(fontSize: 30,fontFamily: 'Custom'),)
                      ]
                ),
        ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/timetable.gif",)),
                          const Expanded(flex: 1,child: Text(textAlign: TextAlign.center,"Time Table",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    )
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                        Expanded(flex: 4,child: Image.asset("assets/images/notes.gif",),),
                        const Expanded(flex: 1,child: Text("Notes",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child:Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/attendance.gif",)),
                          const Expanded(flex: 1,child: Text("Attendance",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/events.gif",)),
                          const Expanded(flex: 1,child: Text("Events",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/message.gif",)),
                          const Expanded(flex: 1,child: Text("Message",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    )
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/result.gif",)),
                          const Expanded(flex: 1,child: Text("Result",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child:Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(""),),
                  Expanded(
                    flex: 2,
                    child: FloatingActionButton(
                      foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        onPressed: () {

                        },
                      child: const Icon(
                          Icons.home_filled

                      )
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FloatingActionButton(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, 'routeName');
                        },
                        child: const Icon(
                            Icons.message
                        )
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FloatingActionButton(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, 'routeName');
                        },
                        child: const Icon(
                            Icons.logout
                        )
                    ),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}

// {
// Row(
// children: [
// Expanded(
// child: FloatingActionButton(
// onPressed: () {
// Navigator.pushNamed(context, 'routeName');
// }
// ),
// ),
// Expanded(
// child: FloatingActionButton(
// onPressed: () {
// Navigator.pushNamed(context, 'routeName');
// }
// ),
// ),
// Expanded(
// child: FloatingActionButton(
// onPressed: () {
// Navigator.pushNamed(context, 'routeName');
// }
// ),
// ),
// ],
// ),
// }