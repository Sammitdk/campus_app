import 'package:flutter/material.dart';
void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: LoginPage(),
));
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.asset("assets/logo.jpg",color: Colors.brown[600],),
          ),
        ],
      ),
    );
  }
}
