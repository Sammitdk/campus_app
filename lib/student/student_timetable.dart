import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class StudentTimeTable extends StatefulWidget {
  final Map<String,dynamic> info;

  const StudentTimeTable({Key? key,required this.info}) : super(key: key);

  @override
  State<StudentTimeTable> createState() => _StudentTimeTableState();
}

class _StudentTimeTableState extends State<StudentTimeTable> {
  Map<String,dynamic> timetable = {};
  Future<Map<String,dynamic>> getTimetable()async {
    DocumentReference timetables = FirebaseFirestore.instance.doc('/College/${widget.info['Branch']}/${widget.info['Year']}/Timetable');
    DocumentSnapshot timetableSnapshot = await timetables.get();
    Map temp = timetableSnapshot.data() as Map<String, dynamic>;
    List l = temp[widget.info['Sem']][DateFormat('EEEE').format(DateTime.now())].keys.toList()..sort();
    l.forEach((element) {
      timetable[element] = temp[widget.info['Sem']][DateFormat('EEEE').format(DateTime.now())][element];
    });
    await Future.delayed(const Duration(milliseconds: 350));
    return timetable;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,dynamic>>(
        future: getTimetable(),
        builder: (context,AsyncSnapshot timetable) {
          if(timetable.connectionState == ConnectionState.waiting){
            return const Scaffold(
             backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator(value: 1)));
          }
            else{
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text("Time Table",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
                  backgroundColor: Colors.indigo[300],
                ),
                body: timetable.data == null? Expanded(child: Lottie.network("https://assets4.lottiefiles.com/private_files/lf30_vdqgavca.json")) : ListView.builder(
                  itemCount: timetable.data.length,
                  itemBuilder: (BuildContext context,int index) {
                    String key = timetable.data.keys.elementAt(index);
                    return Padding(
                      padding: const EdgeInsetsDirectional.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.subject_sharp,
                                  size: 40,
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child:  Row(
                                    children: [
                                      Expanded(flex: 4,
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 100,
                                              // width: 300,
                                              decoration:  BoxDecoration(
                                                borderRadius: const BorderRadiusDirectional.only(
                                                    topStart: Radius.circular(50),
                                                    topEnd: Radius.circular(50),
                                                    bottomStart: Radius.circular(50)),
                                                color: Colors.blue[100],
                                              ),
                                              child: Text(timetable.data[key].toString(),style: const TextStyle(fontSize: 20,fontFamily: 'Custom'),textAlign: TextAlign.center))),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                              height: 100,
                                              // width: 300,
                                              decoration:  BoxDecoration(
                                                borderRadius: const BorderRadiusDirectional.only(
                                                    topStart: Radius.circular(50),
                                                    topEnd: Radius.circular(50),
                                                    bottomEnd: Radius.circular(50),),
                                                color: Colors.blue[100],
                                              ),
                                              child: Text(DateFormat.Hm().format(DateFormat('HH-mm').parse(key)).toString()))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }
    );
    // return Container();
  }
}
