import 'package:campus_subsystem/student/student_message.dart';
import 'package:campus_subsystem/student/student_profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../firebase/signIn.dart';
import 'Student_home.dart';


class StudentDashboard extends StatefulWidget {
  final Map<String,dynamic> info;
  const StudentDashboard({Key? key,required this.info}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {

  final navigationkey = GlobalKey<CurvedNavigationBarState>();
  final Auth auth = Auth();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screen = [
      StudentHome(info: widget.info),
      StudentMessage(info: widget.info),
      StudentProfile(info: widget.info),

    ];
    final items = <Widget>
    [
      const Icon(Icons.home_outlined,size: 30,),
      const Icon(Icons.messenger_outline_rounded,size: 30,),
      const Icon(Icons.person_outline_outlined,size: 30,),
      // const Icon(Icons.logout,size: 30,),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: screen[index],
        bottomNavigationBar: CurvedNavigationBar(
          key: navigationkey,
          backgroundColor: Colors.transparent,
          height: 60,
          items: items,
          index: index,
          onTap: (index) => setState(() { this.index = index;}),
      )

          onTap: (index) => setState(() { this.index = index;print(index);}),
        )
    );
  }
}