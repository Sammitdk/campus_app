import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../components/event.dart';
import '../redux/reducer.dart';

class StudentEvent extends StatefulWidget {
  const StudentEvent({Key? key}) : super(key: key);

  @override
  State<StudentEvent> createState() => _StudentEventState();
}

class _StudentEventState extends State<StudentEvent> {
  @override
  Widget build(BuildContext context) {
    var data = StoreProvider.of<AppState>(context).state;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Events",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      body: Padding(padding: const EdgeInsets.all(15), child: Event(data.isStudent)),
    );
  }
}
