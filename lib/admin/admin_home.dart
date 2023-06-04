import 'package:campus_subsystem/admin/faculty_records_add.dart';
import 'package:campus_subsystem/admin/student_records_add.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const StudentRecordAdd())),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Image.asset(
                        'assets/icons/add_student.gif',
                      ),
                    ),
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Add Students",
                          style:
                              TextStyle(fontFamily: 'Custom', fontSize: 20),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const FacultyRecordsAdd())),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Image.asset(
                        'assets/icons/add_teacher.gif',
                      ),
                    ),
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Add Faculty",
                          style:
                              TextStyle(fontFamily: 'Custom', fontSize: 20),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
