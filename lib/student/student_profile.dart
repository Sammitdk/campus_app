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
              backgroundImage: NetworkImage("https://campussubsytem1.blob.core.windows.net/sammit/shanks.jpg"),
              foregroundColor: Colors.transparent,
              radius: 70,
          ),
          ),
          Positioned(
            top: 30,
            left: 15,
            child: Text("${info['Name']['First']} ${info['Name']['Last']}", style: const TextStyle(fontSize: 40,color: Colors.white,fontFamily:'Bold',),),
          ),
          Positioned(
            top: 83,
            left: 20,
            child: Text("${info['Email']}",style: const TextStyle(fontSize: 20,color: Colors.white,fontFamily:'Narrow',)),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: Text("${info['Mobile']}",style: const TextStyle(fontSize: 20,color: Colors.white,fontFamily:'Narrow',)),
          ),
          Container(
            padding: EdgeInsetsDirectional.only(top: height/2.2,start: 40),
                height: height,
                width: width/1.2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 20),
                      child: Row(
                          children: [
                            const Expanded(
                              flex : 1,
                              child: Icon(
                                Icons.location_city_outlined,
                                size: 50,
                                color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Text("Address",style: TextStyle(fontSize: 15,color: Colors.black,fontFamily:'Narrow',),),
                                  Text("${info['Address']}",style: const TextStyle(fontSize: 25,color: Colors.black,fontFamily:'Narrow',)),
                                ],
                              ),
                            )
                          ],
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 20),
                      child: Row(
                        children: [
                          const Expanded(
                            flex : 1,
                            child: Icon(
                              Icons.school_outlined,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                const Text("Trade",style: TextStyle(fontSize: 15,color: Colors.black,fontFamily:'Narrow',),),
                                Text("${info['Branch']}",style: const TextStyle(fontSize: 25,color: Colors.black,fontFamily:'Narrow',)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 20),
                      child: Row(
                        children: [
                          const Expanded(
                            flex : 1,
                            child: Icon(
                              Icons.cake_outlined,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                const Text("Birth Date",style: TextStyle(fontSize: 15,color: Colors.black,fontFamily:'Narrow',),),
                                Text("${info['DOB']}",style: const TextStyle(fontSize: 25,color: Colors.black,fontFamily:'Narrow',)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 20),
                      child: Row(
                        children: [
                          const Expanded(
                            flex : 1,
                            child: Icon(
                              Icons.numbers,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                const Text("PRN",style: TextStyle(fontSize: 15,color: Colors.black,fontFamily:'Narrow',),),
                                Text("${info['PRN']}",style: const TextStyle(fontSize: 25,color: Colors.black,fontFamily:'Narrow',)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          Container(
            padding: const EdgeInsetsDirectional.only(top: 30,end: 30,bottom: 40),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(onPressed: () async {
              await auth.signOut();
            },
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: const Icon(Icons.logout),
            ),
          )
          ]
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
