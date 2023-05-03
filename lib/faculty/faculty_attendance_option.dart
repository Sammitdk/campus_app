import 'package:campus_subsystem/faculty/faculty_attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../redux/reducer.dart';
import 'faculty_attendance_history.dart';

class FacultyAttendanceOption extends StatefulWidget {
  const FacultyAttendanceOption({Key? key}) : super(key: key);

  @override
  State<FacultyAttendanceOption> createState() => _FacultyAttendanceOptionState();
}

class _FacultyAttendanceOptionState extends State<FacultyAttendanceOption> {
  String selectedsub = '';
  String date = 'Select Date and Time';
  final fkey = GlobalKey<FormState>();
  List<String> subjects = [];

  void timePicker() async {
    TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
    DateTime date = DateUtils.dateOnly(DateTime.now());
    final DateTime? selecteddate =
        await showDatePicker(context: context, initialDate: date, lastDate: DateTime(2030), firstDate: DateTime(2010));
    final TimeOfDay? selectedtime = await showTimePicker(context: context, initialTime: time);
    if (selecteddate != null && selectedtime != null) {
      time = selectedtime;
      date = selecteddate;
      this.date =
          "${DateFormat('dd-MM-yyyy').format(date)}-${DateFormat('HH-mm').format(DateFormat('H:mm a').parse(time.format(context)))}";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // var state = StoreProvider.of<AppState>(context).state;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Attendance",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            // print(state.subject.keys);
            subjects = state.subject.keys.toList();
            // print(subjects);
            return Form(
              key: fkey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FacultyAttendanceHistory()));
                      },
                      icon: const Icon(
                        Icons.history,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "History",
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.indigo[200]),
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        // padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        // height: 80,
                        // color: Colors.grey[300],
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                                child: Text(
                              "Subject",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                margin: const EdgeInsets.all(20),
                                child: ButtonTheme(
                                  child: DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Select Subject.';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.indigo[300],
                                    ),
                                    icon: const Icon(Icons.arrow_drop_down_rounded),
                                    iconEnabledColor: Colors.green,
                                    iconSize: 40,
                                    alignment: AlignmentDirectional.center,
                                    value: selectedsub == "" ? subjects[0] : selectedsub,
                                    items: state.subject.keys.map<DropdownMenuItem<String>>((value) {
                                      // print(value);
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newvalue) {
                                      print(newvalue);
                                      setState(() {
                                        selectedsub = newvalue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              textStyle: const TextStyle(fontFamily: 'MiliBold', fontSize: 18),
                              onPrimary: Colors.black,
                              primary: Colors.white,
                              padding: const EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
                            ),
                            onPressed: () {
                              timePicker();
                            },
                            child: Text(date == 'Select Date and Time'
                                ? date
                                : DateFormat('dd MMM yyyy HH:mm').format(DateFormat('dd-MM-yyyy-HH-mm').parse(date))),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              textStyle: const TextStyle(fontFamily: 'MiliBold', fontSize: 18),
                              onPrimary: Colors.black,
                              primary: Colors.white,
                              padding: const EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
                            ),
                            onPressed: () {
                              if (fkey.currentState!.validate()) {
                                // print(selectedsub);
                                (date != 'Select Date and Time')
                                    ? Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => FacultyAttendance(
                                              references: state.subject[selectedsub],
                                              date: date,
                                              subject: selectedsub,
                                            )))
                                    : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('Select Date and Time'),
                                      ));
                              }
                            },
                            child: const Text('Next'),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Card(color: Colors.white, child: Image.asset("assets/images/attendance.gif")),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
