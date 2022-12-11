import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_subsystem/password_reset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import '../redux/reducer.dart';

class StudentProfile extends HookWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var state = StoreProvider.of<AppState>(context).state;
    File? file;
    final stateUrl = useState(state.imgUrl);
    var clicked = useState(false);
    var progress = useState(0.0);

    Future selectFiles() async {
      final result =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      if (result == null) return;
      final path = result.path;
      file = File(path);
      clicked.value = true;
    }

    Future uploadFile() async {
      if (file == null) return;
      final destination = 'Images/${state.prn}';
      final ref = FirebaseStorage.instance.ref(destination);
      final storageRef = ref.putFile(file!);
      storageRef.snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            progress.value =
                event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
            break;
          case TaskState.paused:
            clicked.value = false;
            break;
          case TaskState.canceled:
            clicked.value = false;
            break;
          case TaskState.error:
            clicked.value = false;
            break;
          case TaskState.success:
            String url = await ref.getDownloadURL();
            stateUrl.value = url;
            await FirebaseFirestore.instance
                .collection("Student_Detail")
                .doc("${state.prn}")
                .update({'imgUrl': url});
            clicked.value = false;
            storageRef.cancel();
            break;
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        SizedBox(
            height: height,
            width: width,
            child: CustomPaint(
              painter: CurvePainter(),
            )),
        Positioned(
            top: height / 8.5,
            left: width / 1.8,
            child: clicked.value && file != null
                ? CircleAvatar(
                    maxRadius: 80,
                    backgroundImage: FileImage(file!),
                  )
                : stateUrl.value != ""
                    ? CachedNetworkImage(
                        imageUrl: stateUrl.value,
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            backgroundImage: imageProvider,
                            maxRadius: 80,
                          );
                        },
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage("assets/images/profile.gif"),
                          maxRadius: 80,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      )
                    : const CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/profile.gif"),
                        maxRadius: 80,
                        backgroundColor: Colors.transparent,
                      )),
        Positioned(
            top: height / 3.50,
            width: width / 0.55,
            child: clicked.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          value: progress.value,
                          color: Colors.black,
                          strokeWidth: 3.0,
                        ),
                        Text(progress.value.toStringAsFixed(2)),
                      ],
                    ),
                  )
                : FloatingActionButton(
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
          child: Text(
            "${state.name['First']}.${state.name['Middle'].toString().substring(0, 1)}.${state.name['Last']}",
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontFamily: 'MuliBold',
            ),
          ),
        ),
        Positioned(
          top: 65,
          left: 20,
          child: Text(state.email,
              style: const TextStyle(fontSize: 20, color: Colors.white)),
        ),
        Positioned(
          top: 100,
          left: 20,
          child: Text(state.mobile,
              style: const TextStyle(fontSize: 20, color: Colors.white)),
        ),
        Container(
          padding: EdgeInsetsDirectional.only(top: height / 2.8, start: 40),
          height: height,
          width: width / 1.2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 20),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
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
                          const Text(
                            "Address",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(state.address,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.black)),
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
                      flex: 1,
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
                          const Text(
                            "Trade",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(state.branch,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.black)),
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
                      flex: 1,
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
                          const Text(
                            "Birth Date",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(state.dob.toString(),
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.black)),
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
                      flex: 1,
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
                          const Text(
                            "PRN",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(state.prn,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.black)),
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
                      flex: 1,
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
                          const Text(
                            "Semester",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(state.sem,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.black)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
      floatingActionButton: SpeedDial(
        closeManually: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            label: 'Forget Password',
            onTap: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ResetPassword()));
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.password),
          ),
          SpeedDialChild(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.logout),
            label: 'Log Out',
            onTap: () async {
              // todo internet connection check before delete(Token)

              try {
                if (state.isStudent) {
                  // remove student device token
                  await FirebaseFirestore.instance
                      .doc("Student_Detail/${state.prn}")
                      .update({"Token": FieldValue.delete()}).then(
                          (value) => FirebaseAuth.instance.signOut());

                  FirebaseFirestore.instance
                      .doc("Student_Detail/${state.prn}")
                      .update({"status": "Offline"});

                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.pushReplacementNamed(context, "loading_page"));
                } else {
                  // remove faculty device token
                  await FirebaseFirestore.instance
                      .doc("Faculty_Detail/${state.email}")
                      .update({"Token": FieldValue.delete()});
                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.pushReplacementNamed(context, "loading_page"));
                }
                // FirebaseAuth.instance.signOut();
              } on FirebaseAuthException catch (e) {
                if (e.code == 'network-request-failed') {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Check Internet Connection.")));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 150, 150);
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

    path.moveTo(0, size.height / 1.9);
    path.quadraticBezierTo(
        size.height / 3, size.height * 0.100, size.width, size.height * 0.200);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
