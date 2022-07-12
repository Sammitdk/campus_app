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
        key: fkey,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                // padding: const EdgeInsetsDirectional.only(
                //     start: 20, top: 70, end: 20,bottom: 10),
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selct Subject.*'),
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
                        print(widget.info['Subjects'][selectedsub]);
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
                        : DateFormat('dd/MM/yyyy HH:mm')
                            .format(DateFormat('dd-MM-yyyy-HH-mm').parse(date))),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
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
                                subject: widget.info['Subjects'][selectedsub],
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
    );
  }
}
