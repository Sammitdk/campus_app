import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      InternetConnectionChecker().onStatusChange.listen((status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Wrapper()));
            break;
          case InternetConnectionStatus.disconnected:
            break;
        }
      });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/NoInternet.gif"),
          const Text("No Internet",style: TextStyle(fontFamily: 'MuliBold',fontSize: 50),),
        ],
      ),
    );
  }
}
