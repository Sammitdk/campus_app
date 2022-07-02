import 'dart:io';
import 'package:campus_subsystem/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import '../firebase/signIn.dart';
import 'package:path/path.dart';

class StudentProfile extends StatefulWidget {
  final Map<String, dynamic> info;
  const StudentProfile({Key? key, required this.info}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final Auth auth = Auth();

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() => this.image = imagePermanent);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async{
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

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
              left: width/2.5,
              child: Center(
                  child: Container(
                      height: 200,
                      width: 300,
                      child: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        clipper: MyClipper(),
                        child: image != null ? Image.file(image!) : Lottie.network("https://assets5.lottiefiles.com/packages/lf20_lyp6fz8l.json"),
                      )
                  )
              ),
            ),
            Positioned(
                top: height/3.5,
                width: width/0.55,
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  onPressed: (){
                    pickImage();
                  },
                  child: const Icon(Icons.add_photo_alternate_outlined),
                )),
            Positioned(
              top: 30,
              left: 15,
              child: Text("${widget.info['Name']['First']} ${widget.info['Name']['Last']}", style: const TextStyle(fontSize: 40,color: Colors.white,fontFamily:'Bold',),),
            ),
            Positioned(
              top: 83,
              left: 20,
              child: Text("${widget.info['Email']}",style: const TextStyle(fontSize: 20,color: Colors.white,fontFamily:'Narrow',)),
            ),
            Positioned(
              top: 120,
              left: 20,
              child: Text("${widget.info['Mobile']}",style: const TextStyle(fontSize: 20,color: Colors.white,fontFamily:'Narrow',)),
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
                              Text("${widget.info['Address']}",style: const TextStyle(fontSize: 25,color: Colors.black,fontFamily:'Narrow',)),
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
                              Text("${widget.info['Branch']}",style: const TextStyle(fontSize: 25,color: Colors.black,fontFamily:'Narrow',)),
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
                              Text("${widget.info['DOB']}",style: const TextStyle(fontSize: 25,color: Colors.black,fontFamily:'Narrow',)),
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
                              Text("${widget.info['PRN']}",style: const TextStyle(fontSize: 25,color: Colors.black,fontFamily:'Narrow',)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            label: 'Forget Pass',
            onTap: () async {
              //logout pass changed
              await auth.signOut();
              // forget pass
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.password),
          ),
          SpeedDialChild(
            label: 'Log Out',
            onTap: () async {
              await auth.signOut();
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

class MyClipper extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 300, 180);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
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

