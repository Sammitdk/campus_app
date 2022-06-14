import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';


class LoadingPage extends StatefulWidget
{
  const LoadingPage({Key? key}) : super(key: key);
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await Future.delayed(Duration(seconds: 3));
      Navigator.of(this.context).pushReplacement(MaterialPageRoute(builder: (_) => Login()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 50,
              left: 50,
              child: Image.asset("assets/images/logo.jpg",color: Colors.brown[500],)
            ),
            Positioned(
              child: Image.asset("assets/images/main_top.png",height: 150,),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset("assets/images/main_bottom.png",height: 200,),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset("assets/images/login_bottom.png",height: 150,),
            ),
            Positioned(
              right: 0,
              child: Image.asset("assets/images/main_topR.png",height: 200,),
            ),
            Positioned(
              top: 370,
              right: 50,
              left: 40,
              child: Image.asset("assets/icons/login.gif",height: 200,),
            )
          ],
        ),
      ),
    );
  }
}