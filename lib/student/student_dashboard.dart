import 'package:flutter/material.dart';

import '../firebase/signIn.dart';


class StudentDashboard extends StatelessWidget {
  final String prn;
  StudentDashboard({Key? key,required this.prn}) : super(key: key);
  final Auth auth = Auth();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: [
          // const Text("SignOut",style: TextStyle(height: 2,fontFamily:'Custom',fontSize: 15),),
          // IconButton(
          //   icon: const Icon(Icons.account_circle_rounded,size: 35,),
          //   onPressed: () async {
          //     await auth.signOut();
          //   },
          // ),
          TextButton.icon(
              onPressed: () async {
                await auth.signOut();
              },
              label: Text(prn),
              icon: const Icon(Icons.precision_manufacturing_outlined),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
            )
          )
        ],
        title: const Text("Dashboard",style: TextStyle(fontSize: 23),),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/timetable.gif",)),
                          Expanded(flex: 1,child: Text(textAlign: TextAlign.center,"Time Table",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
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
                        Expanded(flex: 1,child: const Text("Notes",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/attendance.gif",)),
                          Expanded(flex: 1,child: const Text("Attendance",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
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
                          Expanded(flex: 1,child: const Text("Events",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 4,child: Image.asset("assets/images/message.gif",)),
                          Expanded(flex: 1,child: const Text("Message",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
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
                          Expanded(flex: 1,child: const Text("Result",style: TextStyle(fontFamily: 'Custom',fontSize: 20),)),
                        ],
                      ),
                    )
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

