import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {
  final Map<String, dynamic> info;
  final FirebaseAuth auth = FirebaseAuth.instance;
  StudentProfile({Key? key, required this.info}) : super(key: key);

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
              backgroundImage: NetworkImage("data:image/jpeg;base64,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"),
              foregroundColor: Colors.transparent,
              radius: 70,
          ),
          ),
          Positioned(
            top: 30,
            left: 15,
            child: Text("${info['Name']['First']} ${info['Name']['Last']}", style: const TextStyle(fontSize: 35,color: Colors.white,fontFamily:'Bold',),),
          ),
          Positioned(
            top: 75,
            left: 20,
            child: Text("${info['Email']}",style: const TextStyle(fontSize: 15,color: Colors.white,fontFamily:'Narrow',)),
          ),
          Positioned(
                top: height/2,
                left: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.cake,
                          size: 40,
                          color: Colors.blue,
                        ),
                        Padding(
                            padding: const EdgeInsetsDirectional.only(start: 20),
                            child: Text("${info['DOB']}",style: const TextStyle(fontSize: 20,color: Colors.black,fontFamily:'Narrow',))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_city_sharp,
                          size: 40,
                          color: Colors.blue,
                        ),
                        Padding(
                            padding: const EdgeInsetsDirectional.only(start: 20),
                            child: Text("${info['Address']}",style: const TextStyle(fontSize: 20,color: Colors.black,fontFamily:'Narrow',))),
                      ],
                    ),
                  ],
                ),
              ),
          ]
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blueAccent;
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