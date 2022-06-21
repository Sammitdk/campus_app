import 'package:campus_subsystem/firebase/signIn.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(Auth.signIn(
      username: '2019087344',
      password: 'RAJV25012002'
    ));
    // return LoadingPage();
    return Text('data');
  }
}
