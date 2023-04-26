import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_subsystem/login_page.dart';
import 'package:campus_subsystem/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../password_reset.dart';
import '../redux/reducer.dart';

class FacultyProfile extends HookWidget {
  const FacultyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<AppState>(context).state;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    File? file;
    var stateUrl = useState(state.imgUrl);

    var clicked = useState(false);
    var progress = useState(0.0);

    Future selectFiles() async {
      final result = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      if (result == null) return;
      final path = result.path;
      file = File(path);
      clicked.value = true;
    }

    Future uploadFile() async {
      if (file == null) return;
      final destination = 'Images/${state.email}';
      final ref = FirebaseStorage.instance.ref(destination);
      final storageRef = ref.putFile(file!);
      storageRef.snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            progress.value = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
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
            await FirebaseFirestore.instance.collection("Faculty_Detail").doc(state.email).update({'imgUrl': url});
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
          top: MediaQuery.of(context).size.height * 0.10,
          left: MediaQuery.of(context).size.width * 0.55,
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Align(
                // alignment: AlignmentDirectional.centerEnd,
                child: clicked.value && file != null
                    ? CircleAvatar(
                        maxRadius: MediaQuery.of(context).size.height * 0.1,
                        backgroundImage: FileImage(file!),
                      )
                    : stateUrl.value != "" && stateUrl.value != null
                        ? CachedNetworkImage(
                            imageUrl: stateUrl.value,
                            imageBuilder: (context, imageProvider) {
                              return CircleAvatar(
                                backgroundImage: imageProvider,
                                maxRadius: MediaQuery.of(context).size.height * 0.1,
                              );
                            },
                            placeholder: (context, url) => CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: const AssetImage("assets/images/profile.gif"),
                              maxRadius: MediaQuery.of(context).size.height * 0.1,
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                          )
                        : CircleAvatar(
                            backgroundImage: const AssetImage("assets/images/profile.gif"),
                            maxRadius: MediaQuery.of(context).size.height * 0.1,
                            backgroundColor: Colors.transparent,
                          ),
              ),
              clicked.value
                  ? Align(
                      heightFactor: 0.1,
                      widthFactor: 0.7,
                      child: CircularPercentIndicator(
                        radius: 28.0,
                        lineWidth: 8.0,
                        animation: true,
                        percent: progress.value,
                        center: Text(
                          progress.value.toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        header: const Text(
                          "Uploading",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.purple,
                      ),
                    )
                  : IconButton(
                      // elevation: 0,
                      // backgroundColor: Colors.transparent,
                      // foregroundColor: Colors.black,
                      onPressed: () async {
                        await selectFiles();
                        await uploadFile();
                      },
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                    ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${state.name['First'].toString().capitalize()}.${state.name['Middle'].substring(0, 1).toString().capitalize()}.${state.name['Last'].toString().capitalize()}",
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: 'MuliBold',
                    ),
                  ),
                  Text(state.email ?? "--", style: const TextStyle(fontSize: 20, color: Colors.white)),
                  Text(state.mobile ?? '--', style: const TextStyle(fontSize: 20, color: Colors.white)),
                  // Stack(
                  //   children: [
                  //     Align(
                  //       alignment: AlignmentDirectional.centerEnd,
                  //       child: clicked.value && file != null
                  //           ? CircleAvatar(
                  //         maxRadius: 80,
                  //         backgroundImage: FileImage(file!),
                  //       )
                  //           : stateUrl.value != "" && stateUrl.value != null
                  //           ? CachedNetworkImage(
                  //         imageUrl: stateUrl.value,
                  //         imageBuilder: (context, imageProvider) {
                  //           return CircleAvatar(
                  //             backgroundImage: imageProvider,
                  //             maxRadius: 80,
                  //           );
                  //         },
                  //         placeholder: (context, url) =>
                  //         const CircleAvatar(
                  //           backgroundColor: Colors.transparent,
                  //           backgroundImage:
                  //           AssetImage("assets/images/profile.gif"),
                  //           maxRadius: 80,
                  //         ),
                  //         errorWidget: (context, url, error) =>
                  //         const Icon(Icons.error),
                  //         fit: BoxFit.cover,
                  //       )
                  //           : const CircleAvatar(
                  //         backgroundImage:
                  //         AssetImage("assets/images/profile.gif"),
                  //         maxRadius: 80,
                  //         backgroundColor: Colors.transparent,
                  //       ),
                  //     ),
                  //     Align(
                  //       alignment: AlignmentDirectional.bottomEnd,
                  //       child: IconButton(
                  //         // elevation: 0,
                  //         // backgroundColor: Colors.transparent,
                  //         // foregroundColor: Colors.black,
                  //         onPressed: () async {
                  //           await selectFiles();
                  //           await uploadFile();
                  //         },
                  //         icon: const Icon(Icons.add_photo_alternate_outlined),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // FutureBuilder(
                    //   future: FirebaseFirestore.instance
                    //       .doc("College/${state.branch}/${state.year}/Subjects")
                    //       .get(),
                    //   builder: (BuildContext context, AsyncSnapshot list) {
                    //     if (list.connectionState == ConnectionState.waiting) {
                    //       return Container(
                    //         color: Colors.white,
                    //         child: Center(
                    //             child: LoadingAnimationWidget.staggeredDotsWave(
                    //                 size: 50, color: Colors.red)),
                    //       );
                    //     } else {
                    //       subjectlist = list.data.data()[state.sem].values.toList();
                    //       return StreamBuilder(
                    //           stream: FirebaseFirestore.instance
                    //               .collection("Student_Detail/${state.prn}/Attendance")
                    //               .snapshots(),
                    //           builder: (context, AsyncSnapshot data) {
                    //             if (data.connectionState != ConnectionState.waiting) {
                    //               if (data.hasData) {
                    //                 return Padding(
                    //                   padding: const EdgeInsets.only(
                    //                       left: 20, right: 20, top: 10, bottom: 10),
                    //                   child: Card(
                    //                     elevation: 5,
                    //                     shape: RoundedRectangleBorder(
                    //                         borderRadius: BorderRadius.circular(20)),
                    //                     child: InkWell(
                    //                       onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudentAttendance())),
                    //                       child: Container(
                    //                         margin: EdgeInsets.all(
                    //                             MediaQuery.of(context).size.height *
                    //                                 0.01),
                    //                         child: PieChart(
                    //                           centerText: "Attendance",
                    //                           initialAngleInDegree: 270,
                    //                           chartType: ChartType.ring,
                    //                           chartValuesOptions:
                    //                           const ChartValuesOptions(
                    //                               showChartValuesInPercentage: true,
                    //                               showChartValuesOutside: true,
                    //                               showChartValues: true
                    //                           ),
                    //                           legendOptions: const LegendOptions(
                    //                             legendShape: BoxShape.circle,
                    //                             legendTextStyle: TextStyle(
                    //                               fontSize: 10,
                    //                               fontWeight: FontWeight.bold,
                    //                             ),
                    //                           ),
                    //                           animationDuration:
                    //                           const Duration(seconds: 1),
                    //                           chartRadius:
                    //                           MediaQuery.of(context).size.height *
                    //                               0.1,
                    //                           ringStrokeWidth: 20,
                    //                           dataMap: getChartValues(data),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 );
                    //               } else {
                    //                 return Align(
                    //                     alignment: AlignmentDirectional.centerStart,
                    //                     child: CircularProgressIndicator());
                    //               }
                    //             } else {
                    //               return const Align(
                    //                   alignment: AlignmentDirectional.centerStart,
                    //                   child: CircularProgressIndicator());
                    //             }
                    //           });
                    //     }
                    //   },
                    // ),
                    // state.address != null?Padding(
                    //   padding: const EdgeInsetsDirectional.only(bottom: 20),
                    //   child: Row(
                    //     children: [
                    //       const Expanded(
                    //         flex: 1,
                    //         child: Icon(
                    //           Icons.location_city_outlined,
                    //           size: 50,
                    //           color: Colors.blue,
                    //         ),
                    //       ),
                    //       Expanded(
                    //         flex: 2,
                    //         child: Column(
                    //           children: [
                    //             const Text(
                    //               "Address",
                    //               style: TextStyle(
                    //                   fontSize: 15, color: Colors.black),
                    //             ),
                    //             Text(state.address,
                    //                 style: const TextStyle(
                    //                     fontSize: 25, color: Colors.black)),
                    //           ],
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ):Container(),
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
                                Text(state.address ?? "--", style: const TextStyle(fontSize: 25, color: Colors.black)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
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
                                Text(state.branch ?? "--", style: const TextStyle(fontSize: 25, color: Colors.black)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
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
                                Text(state.dob ?? '--', style: const TextStyle(fontSize: 25, color: Colors.black)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.subject.keys.length,
                              itemBuilder: (context, index) {
                                return Row(children: [
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
                                      child: Text(
                                        state.subject.keys.elementAt(index),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                ]);
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
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
              try {
                if (state.isStudent) {
                  // remove student device token
                  await FirebaseFirestore.instance
                      .doc("Student_Detail/${state.prn}")
                      .update({"Token": FieldValue.delete()}).then((value) => FirebaseAuth.instance.signOut());

                  FirebaseFirestore.instance.doc("Student_Detail/${state.prn}").update({"status": "Offline"});

                  FirebaseAuth.instance.signOut().then((value) => Navigator.pushReplacementNamed(context, "loading_page"));
                } else {
                  // remove faculty device token
                  await FirebaseFirestore.instance.doc("Faculty_Detail/${state.email}").update({"Token": FieldValue.delete()});
                  FirebaseAuth.instance.signOut().then((value) => Navigator.pushReplacementNamed(context, "loading_page"));
                }
                // FirebaseAuth.instance.signOut();
              } on FirebaseAuthException catch (e) {
                if (e.code == 'network-request-failed') {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Check Internet Connection.")));
                }
              }
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const Login()));
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

    path.moveTo(0, size.height / 1.9);
    path.quadraticBezierTo(size.height / 3, size.height * 0.100, size.width, size.height * 0.200);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
