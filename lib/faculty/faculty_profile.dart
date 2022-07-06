import 'package:campus_subsystem/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FacultyProfile extends StatelessWidget {

  Map<String, dynamic> info = {};

  FacultyProfile({Key? key,required this.info}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
          children:[
            SizedBox(
                height: height,
                width: width,
                child:  CustomPaint(
                  painter: CurvePainter(),
                )),
            Positioned(
              top: height/10,
              left: width/1.8,
              child: const CircleAvatar(
                foregroundColor: Colors.transparent,
                radius: 70,
              ),
            ),
          ]
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            label: 'Forget Pass',
            onTap: () async {
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.password),
          ),
          SpeedDialChild(
            label: 'Log Out',
            onTap: () async {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const Login()));
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blueGrey;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height/1.9);
    path.quadraticBezierTo(size.height/3, size.height * 0.100,
        size.width, size.height * 0.200);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);


    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
