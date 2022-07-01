import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StudentNotes extends StatefulWidget {
  const StudentNotes({Key? key}) : super(key: key);

  @override
  State<StudentNotes> createState() => _StudentNotesState();
}

class _StudentNotesState extends State<StudentNotes> {
  Reference storageiref = FirebaseStorage.instance.ref();
  // var storagefile;
  // Future getList() async{
  //   var temp = storageref.ref().child('images');
  //   storagefile = await temp.listAll();
  // }
  // @override
  // void initState(){
  //   WidgetsBinding.instance.addPostFrameCallback((_)async{
  //     await getList();
  //     await Future.delayed(Duration(seconds: 1));
  //     for(var file in storagefile.prefixes){
  //       print(file);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: Icon(Icons.download_rounded),
          onPressed: ()async{
            final islandRef = storageiref.child("images/island.jpg");

            final appDocDir = await getApplicationDocumentsDirectory();
            final filePath = "${appDocDir.absolute}/images/island.jpg";
            final file = File(filePath);

            final downloadTask = islandRef.writeToFile(file);
            downloadTask.snapshotEvents.listen((taskSnapshot) {
              switch (taskSnapshot.state) {
                case TaskState.running:
                // TODO: Handle this case.
                  break;
                case TaskState.paused:
                // TODO: Handle this case.
                  break;
                case TaskState.success:
                // TODO: Handle this case.
                  break;
                case TaskState.canceled:
                // TODO: Handle this case.
                  break;
                case TaskState.error:
                // TODO: Handle this case.
                  break;
              }
            });
          },
        ),
      ),
    );
  }
}
