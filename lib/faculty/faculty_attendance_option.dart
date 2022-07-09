import 'package:campus_subsystem/faculty/faculty_attendance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyAttendanceOption extends StatefulWidget {
  Map<String, dynamic> info = {};
  FacultyAttendanceOption({Key? key, required this.info}) : super(key: key);

  @override
  State<FacultyAttendanceOption> createState() =>
      _FacultyAttendanceOptionState();
}

class _FacultyAttendanceOptionState extends State<FacultyAttendanceOption> {
  String selectedsub = '';
  String date = '';

  void timePicker() async {
    TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
    DateTime date = DateUtils.dateOnly(DateTime.now());
    print(time);
    final DateTime? selecteddate = await showDatePicker(
        context: context,
        initialDate: date,
        lastDate: DateTime(2030),
        firstDate: DateTime(2010)
    );
    final TimeOfDay? selectedtime = await showTimePicker(context: context,initialTime: time);
    if (selecteddate != null && selectedtime!=null) {
      time = selectedtime;
      date = selecteddate;
    }

    this.date = "${DateFormat('dd-MM-yyyy').format(date)}-${DateFormat('HH-mm').format(DateFormat('H:mm a').parse(time.format(context)))}";
    // String str = time.format(context);
    // print(DateTime(date.day,date.month,date.year,time.hour,time.minute));
    // print(DateFormat.Hm().format(DateTime(time.hour,time.minute)));
    // print(('aaaaaaaaaaaaaaaaaaaaa${DateFormat('dd-MM-yyyy').format(date)}-${time.hour}-${time.minute}'));
    // print(time);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    List subjects = widget.info['Subjects'].keys.toList();
    // return Container();
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
        child: Column(
          children: [

            Container(
              margin:
                  const EdgeInsetsDirectional.only(start: 20, top: 70, end: 20,bottom: 40),
              alignment: Alignment.center,
              height: 80,
              child: DropdownButtonFormField<String>(
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
                  print(widget.info['Subjects'][selectedsub]);
                },
              ),
            ),
            // Container(
            //   margin: const EdgeInsetsDirectional.only(
            //       start: 15, top: 30, end: 15),
            //   alignment: Alignment.center,
            //   height: 80,
            //   child: DropdownButtonFormField<String>(
            //     alignment: AlignmentDirectional.center,
            //     value: selectedyear,
            //     items: year.map<DropdownMenuItem<String>>((String br) =>
            //         DropdownMenuItem<String>(value: br, child: Text(br)))
            //         .toList(),
            //     onChanged: (newvalue) {
            //       selectedyear = newvalue!;
            //     },
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsetsDirectional.only(
            //       start: 15, top: 30, end: 15, bottom: 40),
            //   alignment: Alignment.center,
            //   height: 80,
            //   child: DropdownButtonFormField<String>(
            //     alignment: AlignmentDirectional.center,
            //     value: selectedsem,
            //     items: sem.map<DropdownMenuItem<String>>((String br) =>
            //         DropdownMenuItem<String>(value: br, child: Text(br)))
            //         .toList(),
            //     onChanged: (newvalue) {
            //       selectedsem = newvalue!;
            //     },
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    textStyle:
                    const TextStyle(fontFamily: 'MiliBold', fontSize: 18),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 15, right: 15),
                  ),
                  onPressed: timePicker,
                  child: Text(date.isEmpty?'Select Date':DateFormat('dd/MM/yyyy HH:mm').format(DateFormat('dd-MM-yyyy-HH-mm').parse(date))),
                ),
                const SizedBox(width: 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle:
                    const TextStyle(fontFamily: 'MiliBold', fontSize: 18),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 15, right: 15),
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FacultyAttendance(
                        subject: widget.info['Subjects'][selectedsub],
                        date: date,
                      ))),
                  child: const Text('Next'),
                )
              ],
            ),
            Expanded(
                child: Card(
                  color: Colors.white,
                    child: Image.asset("assets/images/attendance.gif")),
            )
          ],
        ),
      ),
    );
  }
}
