import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  Main()
);

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
    );
  }
}
