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
  String date = '';
  final fkey = GlobalKey<FormState>();
  List<String> subjects = [];

  void timePicker() async {
    TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
    DateTime date = DateUtils.dateOnly(DateTime.now());
    TimeOfDay? selectedtime;
    final DateTime? selecteddate = await showDatePicker(
      context: context,
      initialDate: date,
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: Colors.indigo[300]!, onPrimary: Colors.white, onSurface: Colors.black54),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.indigo[300], // button text color
                ),
              ),
            ),
            child: child!);
      },
      lastDate: DateTime.now(),
      firstDate: DateTime(2010),
    ).then((value) async {
      if (value != null) {
        selectedtime = await showTimePicker(
            context: context,
            initialTime: time,
            builder: (context, child) {
              return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(primary: Colors.indigo[300]!, onPrimary: Colors.white, onSurface: Colors.black54),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.indigo[300], // button text color
                      ),
                    ),
                  ),
                  child: child!);
            });
      }
      return value;
    });
   
    if (selecteddate != null && selectedtime != null) {
      time = selectedtime!;
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
            //
            subjects = state.subject.keys.toList();
            //
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.indigo[300]),
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
                              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                margin: const EdgeInsets.all(20),
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButtonFormField<String>(
                                    decoration:
                                        const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(color: Colors.white)),
                                    icon: const Icon(Icons.arrow_drop_down_rounded),
                                    iconEnabledColor: Colors.green,
                                    iconSize: 20,
                                    alignment: AlignmentDirectional.center,
                                    value: selectedsub == "" ? selectedsub = state.subject.keys.elementAt(0) : selectedsub,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Select Subject.';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 20,
                                      color: Colors.indigo[300],
                                    ),
                                    hint: const Text(
                                      "Select.",
                                    ),
                                    items: state.subject.keys
                                        .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.center,
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (newvalue) {
                                     
                                      if (newvalue != selectedsub) {
                                        setState(() {
                                          selectedsub = newvalue!;
                                        });
                                      }
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
                          FloatingActionButton.extended(
                            onPressed: () {
                              timePicker();
                            },
                            heroTag: null,
                            backgroundColor: Colors.indigo[300],
                            icon: const Icon(Icons.calendar_month),
                            label: Text(date.isEmpty
                                ? 'Select Date and Time'
                                : DateFormat('dd MMM yyyy HH:mm').format(DateFormat('dd-MM-yyyy-HH-mm').parse(date))),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          FloatingActionButton.extended(
                            heroTag: null,
                            backgroundColor: Colors.indigo[300],
                            onPressed: () {
                              if (fkey.currentState!.validate()) {
                               
                                (date.isNotEmpty)
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
                            label: const Text(
                              'Next',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
