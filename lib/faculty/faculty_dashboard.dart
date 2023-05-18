import 'package:campus_subsystem/faculty/faculty_home.dart';
import 'package:campus_subsystem/faculty/faculty_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../messaging/conversation_screen.dart';

class FacultyDashboard extends StatefulWidget {
  final String email;

  const FacultyDashboard({Key? key, required this.email}) : super(key: key);

  @override
  State<FacultyDashboard> createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> with WidgetsBindingObserver {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  void setStatus(String status) {
    FirebaseFirestore.instance.doc("Messages/${widget.email}").set({'status': status}, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();
    setStatus("Online");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = [
      const FacultyHome(),
      const ConversationScreen(
        isFaculty: true,
      ),
      FacultyProfile(),
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
        bottomNavigationBar: CurvedNavigationBar(
          key: navigationKey,
          backgroundColor: Colors.transparent,
          height: 60,
          items: items,
          index: index,
          onTap: (index) {
            setState(() {
              this.index = index;
            });
          },
        ));
  }
}
