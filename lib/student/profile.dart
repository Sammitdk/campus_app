import 'package:campus_subsystem/student/student_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context)
  {
    // final prn = Provider.of<QuerySnapshot>(context);
    // return StreamProvider<QuerySnapshot?>.value(
    //   value: StudentDashboard(),
    //   initialData: null,
      return Scaffold(
        body: Container(
          child: const Text("Hello"),
        ),
    //   ),
    );
  }
}
