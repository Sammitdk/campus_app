import 'dart:async';
import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:campus_subsystem/redux/actions/fetchUserData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'firebase_options.dart';

class LoadingPage extends StatefulWidget {
  // final String? email;

  LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (auth.currentUser?.email != null) {
        await FetchData().fetchUserData(auth.currentUser?.email).onError((error, stackTrace) {
          print("$error   $stackTrace");
        });
      }
      Future.delayed(const Duration(milliseconds: 3000), () => {Navigator.pushReplacementNamed(context, 'main')});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenheight,
        width: screenwidth,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
                top: 10,
                right: 50,
                left: 50,
                child: Image.asset(
                  "assets/images/logo.jpg",
                  color: Colors.brown[500],
                )),
            Positioned(
              child: Image.asset(
                "assets/images/main_top.png",
                height: 150,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                height: 200,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/login_bottom.png",
                height: 150,
              ),
            ),
            Positioned(
              right: 0,
              child: Image.asset(
                "assets/images/main_topR.png",
                height: 200,
              ),
            ),
            Positioned(
              top: 370,
              right: 50,
              left: 40,
              child: Image.asset(
                "assets/icons/login.gif",
                height: 200,
              ),
            )
          ],
        ),
      ),
    );
  }
}
