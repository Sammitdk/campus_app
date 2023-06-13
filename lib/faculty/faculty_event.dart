import 'package:campus_subsystem/faculty/faculty_sub_event.dart';
import 'package:campus_subsystem/redux/reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../components/event.dart';

class FacultyEvent extends StatefulWidget {
  const FacultyEvent({Key? key}) : super(key: key);

  @override
  State<FacultyEvent> createState() => _FacultyEventState();
}

class _FacultyEventState extends State<FacultyEvent> {
  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<AppState>(context).state;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Event",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => FacultySubEvent(email: state.email)));
          }),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Event(state.isStudent),
      ),
    );
  }
}
