import 'dart:io';
import 'package:campus_subsystem/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import '../password_reset.dart';
import '../redux/reducer.dart';

class FacultyProfile extends StatefulWidget {

  const FacultyProfile({Key? key}) : super(key: key);

  @override
  State<FacultyProfile> createState() => _FacultyProfileState();
}

class _FacultyProfileState extends State<FacultyProfile> {
  File? file;

  Future selectFiles() async{
    final result = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if(result == null) return;
    final path = result.path;
    setState(() => file = File(path));
  }

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<AppState>(context).state;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final stateurl = useState(state.imgUrl);

    Future uploadFile() async {
      if(file == null) return;
      final destination = 'Images/${state.email}';
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.putFile(file!);
      String url = await ref.getDownloadURL();
      stateurl.value = url;
      await FirebaseFirestore.instance.collection("Faculty_Detail").doc("${state.email}").update({'imgUrl':url});
    }

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
                backgroundColor: Colors.transparent,
                radius: 100,
              ),
            ),
            Positioned(
              top: 65,
              left: 20,
              child: Text("${state.email}",style: const TextStyle(fontSize: 20,color: Colors.white)),
            ),
            Positioned(
              top: 8,
              left: 20,
              child: Text("${state.name['First']}.${state.name['Middle']}.${state.name['Last']}", style: const TextStyle(fontSize: 40,color: Colors.white,fontFamily:'MuliBold',),),
            ),
            Positioned(
                top: height/8.5,
                left: width/1.7,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 80,
                  backgroundImage: stateurl != null ? NetworkImage(state.imgUrl) : const AssetImage("assets/images/profile.gif") as ImageProvider,
                ),
            ),
            Positioned(
                top: height/3.65,
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
            Container(
              padding: EdgeInsetsDirectional.only(top: height/2.4,start: 40),
              height: height,
              width: width/1.2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 20,start: 30,),
                    child:Row(
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          size: 50,
                          color: Colors.blue,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: Column(
                            children: [
                              Text("${state.branch}",style: const TextStyle(fontSize: 20,)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 20,start: 30,),
                    child:Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 50,
                          color: Colors.blue,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: Column(
                            children: [
                              Text("${state.mobile}",style: const TextStyle(fontSize: 20,)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 300,
                                height: 200,
                                child: ListView.builder(
                                  itemCount: state.subject.keys.length,
                                  itemBuilder: (context,index){
                                    return Padding(
                                      padding: const EdgeInsetsDirectional.all(10),
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
                                              child: Text(state.subject.keys.elementAt(index),style: const TextStyle(fontSize: 18,color: Colors.black))),
                                        ]
                                      ),
                                    );
                                  }
                                ),
                              ),
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
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            label: 'Forget Password',
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ResetPassword()));
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
