import 'package:campus_subsystem/login_page.dart';
import 'package:campus_subsystem/data_loading_page.dart';
import 'package:campus_subsystem/no_internet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  internetConnectionCheck() {
      InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          break;
        case InternetConnectionStatus.disconnected:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NoInternet()));
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // internetConnectionCheck();
    final user = Provider.of<User?>(context);
    if (user == null) {
      return const Login();
    } else {
        final email = user.email!;
        return DataLoading(email: email);
      }
    }

  }
