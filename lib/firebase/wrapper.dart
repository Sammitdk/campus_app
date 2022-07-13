import 'dart:async';

import 'package:campus_subsystem/login_page.dart';
import 'package:campus_subsystem/data_loading_page.dart';
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
  Stream<bool> con() async* {
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
    }
    yield result;
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    Stream<bool> re = con();
    re.listen(print);
    re.map((event) =>
        print('!!!!!!!!!!!!!!!!!!$event'));
    if (user == null) {
      return const Login();
    } else {
      final email = user.email;
      if (email != null) {
        return DataLoading(email: email);
      } else {
        return const Login();
      }
    }

  }
}
