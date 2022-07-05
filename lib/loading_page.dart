import 'dart:async';
import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:flutter/material.dart';


class LoadingPage extends StatefulWidget
{
  const LoadingPage({Key? key}) : super(key: key);
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  double screenheight = 0;
  double screenwidth = 0;
  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)  async {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  Wrapper()));
    });
  }
  @override
  Widget build(BuildContext context) {
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
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
