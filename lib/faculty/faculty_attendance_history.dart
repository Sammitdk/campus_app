import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import '../redux/reducer.dart';

class FacultyAttendanceHistory extends StatefulWidget {
  const FacultyAttendanceHistory({Key? key}) : super(key: key);

  @override
  State<FacultyAttendanceHistory> createState() => _FacultyAttendanceHistoryState();
}

class _FacultyAttendanceHistoryState extends State<FacultyAttendanceHistory> {
  String selectedsubject = '';
  String selecteddate = '';
  List<String> dates = [];
  Map<String, dynamic> attendance = {};
  List rolls = [];

  Future<void> getDateAndAttendance(Map<String, dynamic> subject) async {
    QuerySnapshot attendanceSnap = await FirebaseFirestore.instance
        .collection("College/${subject['branch']}/${subject['year']}/Attendance/$selectedsubject")
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
                            style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
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
                                    hint: const Text('Select.'),
                                    style: TextStyle(fontSize: 20, color: Colors.indigo[300], overflow: TextOverflow.ellipsis),
                                    icon: const Icon(Icons.arrow_drop_down_rounded),
                                    // iconSize: 40,
                                    elevation: 0,
                                    value: selectedsubject.isEmpty ? null : selectedsubject,
                                    iconEnabledColor: Colors.green,
                                    // alignment: AlignmentDirectional.center,
                                    items: state.subject.keys
                                        .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            ))
                                        .toList(),
                                    onChanged: (String? value) async {
                                      if (value != selectedsubject) {
                                        rolls = [];
                                        selecteddate = '';
                                        selectedsubject = value!;
                                        await getDateAndAttendance(state.subject[selectedsubject]);
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
                            style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
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
                                  child: DropdownButton(
                                      elevation: 0,
                                      style: TextStyle(fontSize: 20, color: Colors.indigo[200], overflow: TextOverflow.ellipsis),
                                      icon: const Icon(Icons.arrow_drop_down_rounded),
                                      // iconSize: 40,
                                      iconEnabledColor: Colors.green,
                                      iconDisabledColor: Colors.red,
                                      value: selectedsubject.isNotEmpty ? selecteddate : null,
                                      // alignment: AlignmentDirectional.center,
                                      hint: Text(selectedsubject.isNotEmpty
                                          ? dates.isNotEmpty
                                              ? "Select."
                                              : "No Records added."
                                          : "Select."),
                                      items: dates.isNotEmpty
                                          ? dates.map<DropdownMenuItem<String>>((value) {
                                              return DropdownMenuItem<String>(
                                                value: value.toString(),
                                                child: Text(
                                                    DateFormat('dd  MMM  yyyy hh:mm')
                                                        .format(DateFormat('dd-MM-yyyy-hh-mm').parse(value)),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.center),
                                              );
                                            }).toList()
                                          : null,
                                      onChanged: selectedsubject.isNotEmpty
                                          ? ((String? value) => value != selecteddate
                                              ? setState(() {
                                                  selecteddate = value!;
                                                  rolls = getRolls();
                                                  rolls.sort();
                                                })
                                              : null)
                                          : null),
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
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(DateFormat('dd  MMM  yyyy hh:mm').format(DateFormat('dd-MM-yyyy-hh-mm').parse(selecteddate)),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center),
                          ),
                          IconButton(
                              onPressed: () => showDialogDelete(state.subject),
                              icon: const Icon(
                                Icons.delete_forever_rounded,
                                size: 30,
                                color: Colors.red,
                              ))
                        ],
                      )
                    : Container(),

                // attendance grid
                Expanded(
                  child: attendance.isNotEmpty && selecteddate.isNotEmpty && attendance[selecteddate].isNotEmpty
                      ? GridView.builder(
                          scrollDirection: Axis.vertical,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                          ),
                          itemCount: rolls.length,
                          itemBuilder: (context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: attendance[selecteddate][rolls[index]] ? Colors.green[200] : Colors.red[200],
                                ),
                                child: Center(child: Text(rolls[index].toString())),
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

  showDialogDelete(subject) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              title: const Text(
                "Delete",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(margin: const EdgeInsets.all(5), child: const Text("Do you want to delete Test Result of ")),
                    Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          "$selecteddate ?",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ))
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo[300]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      CollectionReference ref = FirebaseFirestore.instance
                          .collection("College/${subject[selectedsubject]['branch']}/${subject[selectedsubject]['year']}");
                      ref
                          .doc("Attendance/$selectedsubject/$selecteddate")
                          .delete()
                          .onError((error, stackTrace) => print("$error   $stackTrace"))
                          .then((_) {
                        setState(() {
                          selectedsubject = '';
                          selecteddate = '';
                          dates = [];
                          attendance = {};
                          rolls = [];
                          // total = 0;
                        });
                      });
                      deleteForEveryStudent(ref);
                    },
                    child: const Text("Yes")),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo[300]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("No"))
              ],
            ));
  }

  void deleteForEveryStudent(CollectionReference deptyear) {
    deptyear.doc("Roll_No").get().then((docsnap) {
      (docsnap.data()! as Map<String, dynamic>).forEach((roll, ref) {
        try {
          print(" wwwwwwwww $selecteddate");
          ref.collection('Attendance').doc(selectedsubject).update({selecteddate: FieldValue.delete()});
        } on FirebaseException {}
      });
    });
  }
}
