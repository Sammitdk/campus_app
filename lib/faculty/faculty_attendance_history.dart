import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../redux/reducer.dart';

class FacultyAttendanceHistory extends StatefulWidget {
  @override
  State<FacultyAttendanceHistory> createState() =>
      _FacultyAttendanceHistoryState();
}

class _FacultyAttendanceHistoryState extends State<FacultyAttendanceHistory> {
  String selectedsubject = '';
  String selecteddate = '';
  Map datesmap = {};
  Map dates = {};
  var state;


  @override
  Widget build(BuildContext context) {
    state = StoreProvider.of<AppState>(context).state;

    return Scaffold(
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField(
                hint: const Text('Select Subject.'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Select Subject.';
                  }
                  return null;
                },
                elevation: 0,
                iconEnabledColor: Colors.red,
                alignment: AlignmentDirectional.center,
                items: state.subject.keys
                    .toList()
                    .map<DropdownMenuItem<String>>(
                        (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                    .toList(),
                onChanged: (String? value) =>
                  setState(() {
                    selectedsubject = value!;
                  })
                ,
              ),
            ),
          ),
          selectedsubject.isNotEmpty
              ? FutureBuilder(
                builder: (_, AsyncSnapshot<QuerySnapshot> dates) {
                  if(dates.connectionState != ConnectionState.waiting){
                      if (dates.hasData && dates.data!.docs.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField(
                                elevation: 0,
                                iconEnabledColor: Colors.red,
                                alignment: AlignmentDirectional.center,
                                hint: const Text("Select date."),
                                items: dates.data!.docs.map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Text(
                                        DateFormat('dd  MMM  yyyy hh:mm')
                                            .format(
                                                DateFormat('dd-MM-yyyy-hh-mm')
                                                    .parse(value.id)),
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center),
                                  );
                                }).toList(),
                                onChanged: (String? value) => setState(() {
                                      selecteddate = value!;
                                      // print(selecteddate);
                                    })),
                          ),
                        );
                      } else {
                        return const Expanded(
                            child: Center(
                                child: Text(
                          'Records Not Added.',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        )));
                      }
                    } else {
                    return Container();
                  }
                },
            future: state.subject[selectedsubject][0].collection(selectedsubject)
                .orderBy('time',descending: true)
                .get(),
          )
              : Container(),
          selecteddate.isNotEmpty? Text(
              DateFormat('dd  MMM  yyyy hh:mm')
                  .format(
                  DateFormat('dd-MM-yyyy-hh-mm')
                      .parse(selecteddate)),
              style: const TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center) : Container(),
          selectedsubject.isNotEmpty && selecteddate.isNotEmpty
              ? FutureBuilder(
                future: state.subject[selectedsubject][0].collection(selectedsubject).doc(selecteddate).get(),
                builder: (context,AsyncSnapshot snap) {
                    if(snap.connectionState != ConnectionState.waiting){
                      print("if");
                      if (snap.data != null && snap.data.exists) {
                        Map attendance = snap.data.data() as Map;
                        print("nest if");
                        return Expanded(
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                            ),
                            itemCount: attendance.length - 1,
                            itemBuilder: (context, int index) {
                              var key = attendance.keys.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: attendance[key]
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  child: Center(child: Text(key)),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        print("nest else");
                        return Container();
                      }
                    } else {
                      print("else $selecteddate");
                      return Container();
                    }
                  }
              )
              : Container()
        ],
      ),
    );
  }
}
