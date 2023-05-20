import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';

class StudentTimeTable extends StatefulWidget {
  const StudentTimeTable({Key? key}) : super(key: key);

  @override
  State<StudentTimeTable> createState() => _StudentTimeTableState();
}

class _StudentTimeTableState extends State<StudentTimeTable> {
  Map<String, dynamic> timetable = {};

  List weekdays = DateFormat('EEEE').dateSymbols.STANDALONEWEEKDAYS;

  String selectedDay = DateFormat('EEEE').format(DateTime.now());

  Future<Map<String, dynamic>> getTimetable(branch, year) async {
    DocumentReference timetables = FirebaseFirestore.instance.doc('/College/$branch/$year/Timetable');
    DocumentSnapshot timetableSnapshot = await timetables.get();
    Map temp = timetableSnapshot.data() as Map<String, dynamic>;
    List l = temp['6'][selectedDay].keys.toList()..sort();
    for (var element in l) {
      timetable[element] = temp['6'][selectedDay][element];
    }
    await Future.delayed(const Duration(milliseconds: 350));
    return timetable;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, data) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  "Time Table",
                  style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.indigo[300],
              ),
              body: Column(
                children: [
                  Container(
                    color: Colors.indigo[300],
                    child: Row(
                      children: [
                        const Expanded(
                            child: Text(
                          "Day",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                            margin: const EdgeInsets.all(20),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  style: TextStyle(fontSize: 20, color: Colors.indigo[300], overflow: TextOverflow.ellipsis),
                                  icon: const Icon(Icons.arrow_drop_down_rounded),
                                  // iconSize: 40,
                                  iconEnabledColor: Colors.green,
                                  alignment: AlignmentDirectional.center,
                                  value: selectedDay,
                                  items: weekdays
                                      .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          ))
                                      .toList(),
                                  onChanged: (newvalue) {
                                    if (newvalue != selectedDay) {
                                      setState(() {
                                        selectedDay = newvalue!;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future: getTimetable(data.branch, data.year),
                        builder: (context, AsyncSnapshot timetable) {
                          if (timetable.connectionState == ConnectionState.waiting) {
                            return Center(child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red));
                          } else {
                            return timetable.data == null
                                ? Center(
                                    child: Container(
                                        height: MediaQuery.of(context).size.height,
                                        color: Colors.amber[50],
                                        child: Image.asset("assets/images/holiday.gif")))
                                : ListView.builder(
                                    itemCount: timetable.data.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (BuildContext context, int index) {
                                      String key = timetable.data.keys.elementAt(index);
                                      return Padding(
                                        padding: const EdgeInsetsDirectional.all(20),
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.access_time),
                                              )),
                                              Expanded(
                                                flex: 5,
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  height: 80,
                                                  child: Text(timetable.data[key].toString(),
                                                      style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    DateFormat.Hm().format(DateFormat('HH-mm').parse(key)).toString(),
                                                    style: const TextStyle(fontSize: 15),
                                                    overflow: TextOverflow.ellipsis,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          }
                        }),
                  ),
                ],
              ));
        });
  }
}
