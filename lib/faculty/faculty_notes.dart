import 'dart:io';
import 'package:campus_subsystem/loadpdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FacultyNotes extends StatefulWidget {
  const FacultyNotes({Key? key}) : super(key: key);

  @override
  State<FacultyNotes> createState() => _FacultyNotesState();
}

class _FacultyNotesState extends State<FacultyNotes> {
  String url = "";
  int? num;
  bool uploading = false;
  double progress = 0.0;
  dynamic uploadListner;

  uploadDataToFirebase() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      setState(() {
        uploading = false;
      });
    }
    File pick = File(result!.files.single.path.toString());
    var file = pick.readAsBytesSync();
    String fileName = pick.path.split('/').last;

    //uploading
    var pdfFile = FirebaseStorage.instance.ref().child("notes").child(fileName);
    UploadTask task = pdfFile.putData(file);

    uploadListner = task.snapshotEvents.listen((event) async {
      switch (event.state) {
        case TaskState.running:
          setState(() {
            progress =
                event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          });
          break;
        case TaskState.paused:
          setState(() {
            uploading = false;
          });
          break;
        case TaskState.canceled:
          setState(() {
            uploading = false;
          });
          break;
        case TaskState.error:
          setState(() {
            uploading = false;
          });
          break;
        case TaskState.success:
          url = await pdfFile.getDownloadURL();

          //  to cloud firebase

          await FirebaseFirestore.instance.collection("notes").add({
            'url': url,
            'num': fileName,
          });

          setState(() {
            uploading = false;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Notes",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        onPressed: () async {
          setState(() {
            uploading = true;
          });

          await uploadDataToFirebase();
          uploadListner.cancle();
        },
        child: uploading
            ? CircularPercentIndicator(
                radius: 28.0,
                lineWidth: 8.0,
                animation: true,
                percent: progress,
                center: Text(
                  progress.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.orange,
              )
            : const Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("notes").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text(
                  'Files Not Added.',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      QueryDocumentSnapshot x = snapshot.data!.docs[i];
                      return Padding(
                        padding: const EdgeInsetsDirectional.all(20),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LoadPdf(url: x["url"])));
                          },
                          child: Slidable(
                            key: ValueKey(i),
                            endActionPane: ActionPane(
                              extentRatio: 0.23,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(30),
                                  onPressed: (v) async {
                                    FirebaseFirestore.instance
                                        .collection("notes")
                                        .where('num', isEqualTo: x['num'])
                                        .get()
                                        .then((value) => {
                                              FirebaseFirestore.instance
                                                  .collection("notes")
                                                  .doc(value.docs.first.id)
                                                  .delete()
                                            });
                                  },
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFFFE4A49),
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              color: Colors.white,
                              child: Container(
                                alignment: Alignment.center,
                                height: 80,
                                child: Text(
                                  (x["num"]),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
            } else {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    size: 50, color: Colors.red),
              );
            }
          }),
    );
  }
}
