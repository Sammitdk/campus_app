import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentTimeTable extends StatefulWidget {
  Map<String,dynamic> info;

  StudentTimeTable({Key? key,required this.info}) : super(key: key);

  @override
  State<StudentTimeTable> createState() => _StudentTimeTableState();
}

class _StudentTimeTableState extends State<StudentTimeTable> {
  Map<String,dynamic> timetable = {};
  Future<Map<String,dynamic>> getTimetable()async {
    DocumentReference timetables = FirebaseFirestore.instance.doc('/College/${widget.info['Branch']}/${widget.info['Year']}/Timetable');
    DocumentSnapshot timetableSnapshot = await timetables.get();
    return timetableSnapshot.data() as Map<String, dynamic>;
  }
  @override
  Widget build(BuildContext context) {
    print(DateFormat('EEEE').format(DateTime.now()));
    return FutureBuilder<Map<String,dynamic>>(
        future: getTimetable(),
        builder: (context,AsyncSnapshot timetable) {
          if(timetable.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(value: 1,backgroundColor: Colors.transparent,));
          }else{
            if(timetable.hasError){return Text(timetable.error.toString());}
            else{
              // return Text(timetable.data.toString());
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text("Time Table",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
                  backgroundColor: Colors.indigo[300],
                ),
                body: timetable.data[DateFormat('EEEE').format(DateTime.now())] == null? Image.asset('assets/images/holiday.gif') : ListView.builder(
                  itemCount: timetable.data[DateFormat('EEEE').format(DateTime.now())].length,
                  itemBuilder: (BuildContext context,int index) {
                    String key = timetable.data[DateFormat('EEEE').format(DateTime.now())].keys.elementAt(index);
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
                                  child: Container(
                                    // alignment: Alignment.center,
                                    height: 100,
                                    // width: 300,
                                    decoration:  BoxDecoration(
                                        borderRadius: const BorderRadiusDirectional.only(
                                            topStart: Radius.circular(50),
                                            topEnd: Radius.circular(50),
                                            bottomEnd: Radius.circular(50),
                                            bottomStart: Radius.circular(50)),
                                        color: Colors.blue[100],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(flex: 4,child: Text(timetable.data[DateFormat('EEEE').format(DateTime.now())][key].toString(),style: const TextStyle(fontSize: 20,fontFamily: 'Custom'),textAlign: TextAlign.center)),
                                        Expanded(child: Text(DateFormat.Hm().format(DateFormat('hh-mm').parse(key)).toString()))//Text(timetable.data[DateFormat('EEEE').format(DateTime.now())][]))
                                      ],
                                    ),
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
        }
    );
    // return Container();
  }
}
