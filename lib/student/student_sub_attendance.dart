import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentSubAttendance extends StatefulWidget {
  final String sub;
  const StudentSubAttendance({Key? key, required this.sub}) : super(key: key);

  @override
  State<StudentSubAttendance> createState() => _StudentSubAttendanceState();
}

class _StudentSubAttendanceState extends State<StudentSubAttendance> {
  Stream<Map<String, dynamic>> allattend() async* {
    DocumentReference dr = FirebaseFirestore.instance.doc(widget.sub);
    DocumentSnapshot ds = await dr.get();
    yield ds.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    // return RefreshIndicator(
    //   onRefresh: () => Future(() {
    //     setState(() {});
    //   }),
    //   child: FutureBuilder<Map<String, dynamic>>(
    //     future: allattend(),
    //     builder: (context, AsyncSnapshot attendance) {
    //       if (attendance.connectionState == ConnectionState.waiting) {
    //         return const Scaffold(
    //             backgroundColor: Colors.white,
    //             body: Center(
    //                 child: CircularProgressIndicator(
    //                   value: 3,
    //                 )));
    //       } else {
    //         if (attendance.hasError) {
    //           return Text(attendance.error.toString());
    //         } else {
    //           // print(attendance.data.toString());
    //           return Scaffold(
    //             appBar: AppBar(
    //               centerTitle: true,
    //               title: const Text(
    //                 "Attendance",
    //                 style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
    //                 textAlign: TextAlign.center,
    //               ),
    //               backgroundColor: Colors.indigo[300],
    //             ),
    //             body: Padding(
    //               padding: const EdgeInsetsDirectional.all(20),
    //               child: ListView.builder(
    //                 itemCount: attendance.data.length,
    //                 itemBuilder: (BuildContext context, int index) {
    //                   String key = attendance.data.keys
    //                       .elementAt(index); //datetime as per attendance
    //                   return Column(
    //                     children: [
    //                       Padding(
    //                         padding:
    //                         const EdgeInsetsDirectional.only(bottom: 10),
    //                         child: Row(
    //                           children: [
    //                             const Expanded(
    //                               flex: 1,
    //                               child: Icon(
    //                                 Icons.subject_sharp,
    //                                 size: 40,
    //                               ),
    //                             ),
    //                             Expanded(
    //                               flex: 7,
    //                               child: Padding(
    //                                 padding: const EdgeInsets.only(top: 15.0),
    //                                 child: Container(
    //                                   // alignment: Alignment.center,
    //                                   height: 100,
    //                                   // width: 300,
    //                                   decoration: BoxDecoration(
    //                                       borderRadius:
    //                                       const BorderRadiusDirectional
    //                                           .only(
    //                                           topStart: Radius.circular(50),
    //                                           topEnd: Radius.circular(50),
    //                                           bottomEnd:
    //                                           Radius.circular(50),
    //                                           bottomStart:
    //                                           Radius.circular(50)),
    //                                       color: Colors.blue[100]),
    //                                   child: Row(
    //                                     children: [
    //                                       Expanded(
    //                                           flex: 4,
    //                                           child: Text(key,
    //                                               style: const TextStyle(
    //                                                   fontSize: 20,
    //                                                   fontFamily: 'Custom'),
    //                                               textAlign: TextAlign.center)),
    //                                       Expanded(
    //                                         flex: 2,
    //                                         child: Text(attendance.data[key]
    //                                             ? 'Present'
    //                                             : 'Absent',
    //                                             style: const TextStyle(
    //                                               fontSize: 18,)
    //                                         ),
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       )
    //                     ],
    //                   );
    //                 },
    //               ),
    //             ),
    //           );
    //         }
    //       }
    //     },
    //   ),
    // );
    return Scaffold(
      body: StreamBuilder(
        stream: allattend(),
        builder: (context,AsyncSnapshot<Map<String,dynamic>> snapshot){
          print('qqqqqqqqqqqqqqq${snapshot.data}');
          if(snapshot.hasData){
            Map attendance = snapshot.data as Map<String,dynamic >;
            // return Container();
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context,index){
                String key = attendance.keys.elementAt(index);
                return Padding(
                  padding: const EdgeInsetsDirectional.all(20),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.only(bottom: 10),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.subject_sharp,
                                size: 40,
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Container(
                                  // alignment: Alignment.center,
                                  height: 100,
                                  // width: 300,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      const BorderRadiusDirectional
                                          .only(
                                          topStart: Radius.circular(50),
                                          topEnd: Radius.circular(50),
                                          bottomEnd:
                                          Radius.circular(50),
                                          bottomStart:
                                          Radius.circular(50)),
                                      color: Colors.blue[100]),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Text(key,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Custom'),
                                              textAlign: TextAlign.center)),
                                      Expanded(
                                        flex: 2,
                                        child: Text(attendance[key]
                                            ? 'Present'
                                            : 'Absent',
                                            style: const TextStyle(
                                              fontSize: 18,)
                                        ),
                                      )
                                    ],
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
              },
            );
          }else{
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
