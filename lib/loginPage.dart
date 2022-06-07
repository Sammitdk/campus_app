import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ));

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
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
              child: Image.network("assets/images/logo.jpg",color: Colors.brown[500],)
            ),
            Positioned(
              child: Image.network("assets/images/main_top.png",height: 150,),
            ),
            Positioned(
              bottom: 0,
              child: Image.network("assets/images/main_bottom.png",height: 200,),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.network("assets/images/login_bottom.png",height: 150,),
            ),
            Positioned(
              right: 0,
              child: Image.network("assets/images/main_topr.png",height: 200,),
            ),
            Positioned(
              top: 370,
              right: 50,
              left: 40,
              child: Image.network("assets/icons/login.gif",height: 200,),
            )
          ],
        ),
      ),
    );
  }
}
