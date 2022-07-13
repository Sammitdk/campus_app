import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class StudentTimeTable extends StatefulWidget {
  final Map<String,dynamic> info;

  const StudentTimeTable({Key? key,required this.info}) : super(key: key);

  @override
  State<StudentTimeTable> createState() => _StudentTimeTableState();
}

class _StudentTimeTableState extends State<StudentTimeTable> {
  Map<String,dynamic> timetable = {};
  List weekdays = DateFormat('EEEE').dateSymbols.STANDALONEWEEKDAYS;
   String selectedday =   DateFormat('EEEE').format(DateTime.now());
  Future<Map<String,dynamic>> getTimetable()async {
    DocumentReference timetables = FirebaseFirestore.instance.doc('/College/${widget.info['Branch']}/${widget.info['Year']}/Timetable');
    DocumentSnapshot timetableSnapshot = await timetables.get();
    Map temp = timetableSnapshot.data() as Map<String, dynamic>;
    List l = temp[widget.info['Sem']][selectedday].keys.toList()..sort();
    l.forEach((element) {
      timetable[element] = temp[widget.info['Sem']][selectedday][element];
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
            return Scaffold(
             backgroundColor: Colors.white,
                body: Center(child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red)));
          }
            else{
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text("Time Table",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
                  backgroundColor: Colors.indigo[300],
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: DropdownButtonFormField<String>(
                        elevation: 0,
                        iconEnabledColor: Colors.red,
                        alignment: AlignmentDirectional.center,
                        value: selectedday,
                        items: weekdays
                            .map<DropdownMenuItem<String>>(
                                (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                            .toList(),
                        onChanged: (newvalue) {
                          selectedday = newvalue!;
                          setState((){});
                        },
                      ),
                    ),
                    Expanded(
                      child: timetable.data == null? Center(child: Lottie.network("https://assets4.lottiefiles.com/private_files/lf30_vdqgavca.json")) : ListView.builder(
                        itemCount: timetable.data.length,
                        scrollDirection: Axis.vertical,
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
                                      child: Row(
                                        children: [
                                          Expanded(flex: 4,
                                              child: Card(
                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),topLeft: Radius.circular(50),topRight: Radius.circular(50))),
                                                elevation: 5,
                                                color: Colors.blue[100],
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height: 80,
                                                    child: Text(timetable.data[key].toString(),style: const TextStyle(fontSize: 20),textAlign: TextAlign.center)),
                                              )),
                                          const SizedBox(width: 10,),
                                          Expanded(
                                            flex: 1,
                                              child: Card(
                                                elevation: 5,
                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),topLeft: Radius.circular(50),topRight: Radius.circular(50))),
                                                color: Colors.blue[100],
                                                child: Container(
                                                  alignment: Alignment.center,
                                                    height: 80,
                                                    child: Text(DateFormat.Hm().format(DateFormat('HH-mm').parse(key)).toString())),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }
    );
  }
}
