import 'dart:async';

import 'package:campus_subsystem/redux/actions/fetchUserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoadingPage extends HookWidget {
  final String? email;
  const LoadingPage({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    useEffect(() {
      if(email != null){
        fetchUserData(email).then((value) => Navigator.pushReplacementNamed(context, "/"));
      }else{
        Future.delayed(const Duration(milliseconds: 3000)).then((value) =>Navigator.pushReplacementNamed(context, "/"));
      }
    },const []);

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
