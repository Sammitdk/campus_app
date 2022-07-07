import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FacultyEvents extends StatefulWidget {
  const FacultyEvents({Key? key}) : super(key: key);

  @override
  State<FacultyEvents> createState() => _FacultyEventsState();
}

class _FacultyEventsState extends State<FacultyEvents> {
  String url = "";
  late String num ;
  uploadDataToFirebase() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File pick = File(result!.files.single.path.toString());
    var file = pick.readAsBytesSync();
    String fileName = pick.path.split('/').last;

    //uploading
    var pdfFile = FirebaseStorage.instance.ref().child("Events").child(fileName);
    UploadTask task = pdfFile.putData(file);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();

    //  to cloud firebase

    await FirebaseFirestore.instance.collection("notes").doc().set(
        {
          'url':url,
          'num': fileName,
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
