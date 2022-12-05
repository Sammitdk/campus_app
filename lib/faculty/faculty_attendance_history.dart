
import 'package:flutter/material.dart';

class FacultyAttendanceHistory extends StatelessWidget {
  const FacultyAttendanceHistory({super.key});

  Future<List<DropdownMenuItem>> getList() async {
    return [DropdownMenuItem(child: Text("ASASAS"))];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // DropdownButtonFormField(
          //   items: await getList(),
          // )
        ],
      ),
    );
  }
}