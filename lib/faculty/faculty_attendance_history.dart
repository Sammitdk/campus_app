import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import '../redux/reducer.dart';

class FacultyAttendanceHistory extends StatefulWidget {
  const FacultyAttendanceHistory({Key? key}) : super(key: key);

  @override
  State<FacultyAttendanceHistory> createState() =>
      _FacultyAttendanceHistoryState();
}

class _FacultyAttendanceHistoryState extends State<FacultyAttendanceHistory> {
  String selectedsubject = '';
  String selecteddate = '';
  List<String> dates = [];
  Map<String, dynamic> attendance = {};
  List rolls = [];

  Future<void> getDateAndAttendance(Map<String, dynamic> subject) async {
    QuerySnapshot attendanceSnap = await FirebaseFirestore.instance
        .collection(
            "College/${subject['branch']}/${subject['year']}/Attendance/$selectedsubject")
        .orderBy('time', descending: true)
        .get();
    // await subject[0].collection(selectedsubject).get();
    dates = attendanceSnap.docs.map((e) {
      Map temp = (e.data() as Map<String, dynamic>);
      temp.remove('time');
      attendance[e.id] = temp.map((key, value) {
        return MapEntry(int.parse(key), value);
      });
      return e.id;
    }).toList();
    if (dates.isNotEmpty) {
      selecteddate = dates[0];
      rolls = getRolls();
      rolls.sort();
    }
  }

  List getRolls() {
    return attendance[selecteddate].keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return SafeArea(
          // todo remove safe area
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "History",
                style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.indigo[300],
            ),
            body: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  // height: 50,
                  color: Colors.indigo[300],
                  // decoration: BoxDecoration(color: Colors.indigo[300], border: const Border(top: BorderSide(color: Colors.black))),
                  child: Column(
                    children: [
                      // select subject
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                              child: Text(
                            "Subject",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              margin: const EdgeInsets.all(20),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: const Text('Select.'),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.indigo[300],
                                        overflow: TextOverflow.ellipsis),
                                    icon: const Icon(
                                        Icons.arrow_drop_down_rounded),
                                    iconSize: 40,
                                    elevation: 0,
                                    value: selectedsubject.isEmpty
                                        ? null
                                        : selectedsubject,
                                    iconEnabledColor: Colors.green,
                                    alignment: AlignmentDirectional.center,
                                    items: state.subject.keys
                                        .map<DropdownMenuItem<String>>(
                                            (value) => DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                ))
                                        .toList(),
                                    onChanged: (String? value) async {
                                      if (value != selectedsubject) {
                                        rolls = [];
                                        selecteddate = '';
                                        selectedsubject = value!;
                                        await getDateAndAttendance(
                                            state.subject[selectedsubject]);
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // select date
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "Date",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                          Expanded(
                            flex: 2,
                            child: selectedsubject.isNotEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    margin: const EdgeInsets.all(20),
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            elevation: 0,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.indigo[200],
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            icon: const Icon(
                                                Icons.arrow_drop_down_rounded),
                                            iconSize: 40,
                                            iconEnabledColor: Colors.green,
                                            iconDisabledColor: Colors.red,
                                            value: selecteddate,
                                            alignment:
                                                AlignmentDirectional.center,
                                            hint: Text(dates.isNotEmpty
                                                ? "Select."
                                                : "No Records added."),
                                            items: dates.isNotEmpty
                                                ? dates.map<
                                                    DropdownMenuItem<
                                                        String>>((value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value.toString(),
                                                      child: Text(
                                                          DateFormat(
                                                                  'dd  MMM  yyyy hh:mm')
                                                              .format(DateFormat(
                                                                      'dd-MM-yyyy-hh-mm')
                                                                  .parse(
                                                                      value)),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center),
                                                    );
                                                  }).toList()
                                                : null,
                                            onChanged: (String? value) =>
                                                value != selecteddate
                                                    ? setState(() {
                                                        selecteddate = value!;
                                                        rolls = getRolls();
                                                        rolls.sort();
                                                      })
                                                    : null),
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: Colors.indigo[300],
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white),
                                      margin: const EdgeInsets.all(20),
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                              elevation: 0,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.indigo[200],
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_rounded),
                                              iconSize: 40,
                                              iconDisabledColor: Colors.red,
                                              alignment:
                                                  AlignmentDirectional.center,
                                              // hint: const Text("Select date."),
                                              items: null,
                                              onChanged: null),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                selecteddate.isNotEmpty
                    ? Text(
                        DateFormat('dd  MMM  yyyy hh:mm').format(
                            DateFormat('dd-MM-yyyy-hh-mm').parse(selecteddate)),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center)
                    : Container(),

                // attendance grid
                Expanded(
                  child: attendance.isNotEmpty &&
                          selecteddate.isNotEmpty &&
                          attendance[selecteddate].isNotEmpty
                      ? GridView.builder(
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                          ),
                          itemCount: rolls.length,
                          itemBuilder: (context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: attendance[selecteddate][rolls[index]]
                                      ? Colors.green[200]
                                      : Colors.red[200],
                                ),
                                child: Center(
                                    child: Text(rolls[index].toString())),
                              ),
                            );
                          },
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
