import 'package:campus_subsystem/student/student_profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../firebase/signIn.dart';
import '../messaging/test.dart';
import 'student_home.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  final Auth auth = Auth();
  int index = 0;
  bool isShowing = true;

  @override
  Widget build(BuildContext context) {
    final screen = [
      const StudentHome(),
      Test(isShowing: isShowing),
      const StudentProfile(),
    ];
    final items = <Widget>[
      const Icon(
        Icons.home_outlined,
        size: 30,
      ),
      const Icon(
        Icons.messenger_outline_rounded,
        size: 30,
      ),
      const Icon(
        Icons.person_outline_outlined,
        size: 30,
      ),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: screen[index],
        bottomNavigationBar: isShowing ? CurvedNavigationBar(
          key: navigationKey,
          backgroundColor: Colors.transparent,
          height: 60,
          items: items,
          index: index,
          onTap: (index) {
            if(index == 1) {
              setState(() {
                isShowing = false;
              });
            }
            setState(() {
            this.index = index;
          });},
        ) :  InkWell(
          onTap: () {
            setState(() {
              isShowing = true;
            });
          },
          child: Container(
            height: 20,
          ),
        )
    );
  }
}
