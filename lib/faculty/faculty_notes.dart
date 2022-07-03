import 'dart:io';
import 'package:campus_subsystem/student/student_syllabus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FacultyNotes extends StatefulWidget {
  const FacultyNotes({Key? key}) : super(key: key);

  @override
  State<FacultyNotes> createState() => _FacultyNotesState();
}

class _FacultyNotesState extends State<FacultyNotes> {

  String url = "";
  int? num;
  uploadDataToFirebase() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File pick = File(result!.files.single.path.toString());
    var file = pick.readAsBytesSync();
    String fileName = pick.path.split('/').last;

    //uploading
    var pdfFile = FirebaseStorage.instance.ref().child("notes").child(fileName);
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        onPressed: (){
          uploadDataToFirebase();
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notes").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,i){
                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                return InkWell(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_) => LoadFirebasePdf(url: x['url'],)));
                  },
                  child: Expanded(
                    child: Padding(
                      padding:  const EdgeInsetsDirectional.all(10),
                      child: Container(
                        alignment: Alignment.center,
                        height: 80,
                        // width: 300,
                        decoration:  BoxDecoration(
                            borderRadius:
                            const BorderRadiusDirectional.only(
                                topStart: Radius.circular(50),
                                topEnd: Radius.circular(50),
                                bottomEnd: Radius.circular(50),
                                bottomStart: Radius.circular(50)),
                            color: Colors.blue[100]),
                        child: Text((x['num']),textAlign: TextAlign.center,style: const TextStyle(fontFamily: "Bold",fontSize: 30),),
                      ),
                    ),
                  ),
                );
              });
          }
          return const Center(
            child: CircularProgressIndicator(
            ),
          );
        }
      ),
    );
  }
}
