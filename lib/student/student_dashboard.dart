import 'package:flutter/material.dart';
import '../firebase/signIn.dart';

class StudentDashboard extends StatelessWidget {
  final Map<String, dynamic> info;
  StudentDashboard({Key? key, required this.info}) : super(key: key);
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    print(debugDumpApp.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Row(children: [
                  Text(
                    "  Hey ${info['Name']['First']}",
                    style: const TextStyle(fontSize: 30, fontFamily: 'Custom'),
                  )
                ]),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                      child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Image.asset(
                              "assets/images/timetable.gif",
                            )),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Time Table",
                              style:
                                  TextStyle(fontFamily: 'Custom', fontSize: 20),
                            )),
                      ],
                    ),
                  )),
                  Expanded(
                      child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Image.asset(
                            "assets/images/notes.gif",
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              "Notes",
                              style:
                                  TextStyle(fontFamily: 'Custom', fontSize: 20),
                            )),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Image.asset(
                                "assets/images/attendance.gif",
                              )),
                          const Expanded(
                              flex: 1,
                              child: Text(
                                "Attendance",
                                style: TextStyle(
                                    fontFamily: 'Custom', fontSize: 20),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Image.asset(
                                "assets/images/events.gif",
                              )),
                          const Expanded(
                              flex: 1,
                              child: Text(
                                "Events",
                                style: TextStyle(
                                    fontFamily: 'Custom', fontSize: 20),
                              )),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Image.asset(
                              "assets/images/message.gif",
                            )),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              "Message",
                              style:
                                  TextStyle(fontFamily: 'Custom', fontSize: 20),
                            )),
                      ],
                    ),
                  )),
                  Expanded(
                      child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Image.asset(
                              "assets/images/result.gif",
                            )),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              "Result",
                              style:
                                  TextStyle(fontFamily: 'Custom', fontSize: 20),
                            )),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Expanded(
                  //   flex: 3,
                  //   child: Container(),
                  // ),
                  FloatingActionButton(
                      heroTag: null,
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      onPressed: () {},
                      child: const Icon(Icons.home_filled)
                  ),
                  FloatingActionButton(
                      heroTag: null,
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      onPressed: () {},
                      child: const Icon(Icons.message)),
                  FloatingActionButton(
                      heroTag: null,
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        await auth.signOut();
                      },
                      child: const Icon(Icons.logout)),
                  // Expanded(
                  //   flex: 2,
                  //   child:
                  // ),
                  // Expanded(
                  //   flex: 2,
                  //   child:
                  // ),
                  // Expanded(
                  //   flex: 2,
                  //   child:
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
