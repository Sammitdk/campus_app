import 'package:campus_subsystem/loading_page.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoadingPage(),
    );
  }
}
