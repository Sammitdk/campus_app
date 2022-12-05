import 'package:campus_subsystem/faculty/faculty_attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../redux/reducer.dart';

class FacultyAttendanceOption extends StatefulWidget {
  const FacultyAttendanceOption({Key? key}) : super(key: key);

  @override
  State<FacultyAttendanceOption> createState() =>
      _FacultyAttendanceOptionState();
}

class _FacultyAttendanceOptionState extends State<FacultyAttendanceOption> {
  String selectedsub = '';
  String date = 'Select Date and Time';
  final fkey = GlobalKey<FormState>();

  void timePicker() async {
    TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
    DateTime date = DateUtils.dateOnly(DateTime.now());
    print(time);
    final DateTime? selecteddate = await showDatePicker(
        context: context,
        initialDate: date,
        lastDate: DateTime(2030),
        firstDate: DateTime(2010));
    final TimeOfDay? selectedtime =
        await showTimePicker(context: context, initialTime: time);
    if (selecteddate != null && selectedtime != null) {
      time = selectedtime;
      date = selecteddate;
      this.date = "${DateFormat('dd-MM-yyyy').format(date)}-${DateFormat('HH-mm').format(DateFormat('H:mm a').parse(time.format(context)))}";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<AppState>(context).state;
    List subjects = state.subject.keys.toList();
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
      body: Form(
        key: fkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                onPressed: (){
                  // todo
                },
                icon: const Icon(Icons.history,color: Colors.black,),
                label: const Text("History",style: TextStyle(color: Colors.black),),
                backgroundColor: Colors.white,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Subject.'),
                      DropdownButtonFormField<String>(
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Select Subject.';
                          }
                          return null;
                        },
                        alignment: AlignmentDirectional.center,
                        value: null,
                        items: subjects
                            .map<DropdownMenuItem<String>>(
                                (value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ))
                            .toList(),
                        onChanged: (newvalue) {
                          selectedsub = newvalue!;
                        },
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        textStyle:
                            const TextStyle(fontFamily: 'MiliBold', fontSize: 18),
                        onPrimary: Colors.black,
                        primary: Colors.white,
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, left: 15, right: 15),
                      ),
                      onPressed: (){timePicker();
},
                      child: Text(date
                          == 'Select Date and Time'? date
                          : DateFormat('dd MMM yyyy HH:mm')
                              .format(DateFormat('dd-MM-yyyy-HH-mm').parse(date))),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        textStyle:
                        const TextStyle(fontFamily: 'MiliBold', fontSize: 18),
                        onPrimary: Colors.black,
                        primary: Colors.white,
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, left: 15, right: 15),
                      ),
                      onPressed: () {
                        if(fkey.currentState!.validate()) {
                          (date != 'Select Date and Time')?
                            Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => FacultyAttendance(
                                  subject: <String,dynamic>{
                                          selectedsub: state.subject[selectedsub]
                                        },
                                  date: date,
                                )
                            ))
                              :ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select Date and Time'),));
                        }
                      },
                      child: const Text('Next'),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Card(
                    color: Colors.white,
                    child: Image.asset("assets/images/attendance.gif")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
