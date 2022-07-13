import 'dart:io';
import 'package:campus_subsystem/firebase/wrapper.dart';
import 'package:campus_subsystem/password_reset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../firebase/signIn.dart';

class StudentProfile extends StatefulWidget {
  final Map<String,dynamic> info;
  const StudentProfile({Key? key, required this.info}) : super(key: key);
  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {


  final Auth auth = Auth();
  File? file;
  Future selectFiles() async{
    final result = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if(result == null) return;
   final path = result.path;
    setState(() => file = File(path));
  }
  Future uploadFile() async {
    if(file == null) return;
    final destination = 'Images/${widget.info['PRN']}';
    final ref = FirebaseStorage.instance.ref(destination);
    await ref.putFile(file!);
    String url = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection("Student_Detail").doc("${widget.info['PRN']}").update({'url':url});
  }
  void refresh(){
    setState(() {});
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
              top: height/9,
              left: width/2,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                maxRadius: 110,
                child: ClipOval(
                  clipBehavior: Clip.antiAlias,
                  //clipper: MyClipper(),
                  child: widget.info['url']!=null ? Image.network(widget.info['url']) : Lottie.network("https://assets5.lottiefiles.com/packages/lf20_lyp6fz8l.json"),
                ),
              )
            ),
            Positioned(
                top: height/3.0,
                width: width/0.55,
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  onPressed: () async {
                    await selectFiles();
                    await uploadFile();
                  },
                  child: const Icon(Icons.add_photo_alternate_outlined),
                )),
            Positioned(
              top: 8,
              left: 20,
              child: Text("${widget.info['Name']['First']} ${widget.info['Name']['Last']}", style: const TextStyle(fontSize: 40,color: Colors.white,fontFamily:'MuliBold',),),
            ),
            Positioned(
              top: 65,
              left: 20,
              child: Text("${widget.info['Email']}",style: const TextStyle(fontSize: 20,color: Colors.white)),
            ),
            Positioned(
              top: 100,
              left: 20,
              child: Text("${widget.info['Mobile'][0]}",style: const TextStyle(fontSize: 20,color: Colors.white)),
            ),
            Container(
              padding: EdgeInsetsDirectional.only(top: height/2.4,start: 40),
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
                              const Text("Address",style: TextStyle(fontSize: 15,color: Colors.black),),
                              Text("${widget.info['Address']}",style: const TextStyle(fontSize: 25,color: Colors.black)),
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
                              const Text("Trade",style: TextStyle(fontSize: 15,color: Colors.black),),
                              Text("${widget.info['Branch']}",style: const TextStyle(fontSize: 25,color: Colors.black)),
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
                              const Text("Birth Date",style: TextStyle(fontSize: 15,color: Colors.black),),
                              Text("${widget.info['DOB']}",style: const TextStyle(fontSize: 25,color: Colors.black)),
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
                              const Text("PRN",style: TextStyle(fontSize: 15,color: Colors.black),),
                              Text("${widget.info['PRN']}",style: const TextStyle(fontSize: 25,color: Colors.black)),
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
                            Icons.book_outlined,
                            size: 50,
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              const Text("Semester",style: TextStyle(fontSize: 15,color: Colors.black),),
                              Text("${widget.info['Sem']}",style: const TextStyle(fontSize: 25,color: Colors.black)),
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
            label: 'Forget Password',
            onTap: () async {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ResetPassword()));
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.password),
          ),
          SpeedDialChild(
            label: 'Log Out',
            onTap: () async {
              await auth.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>  Wrapper()));
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
    return Rect.fromLTWH(0, 0, 150, 150);
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

