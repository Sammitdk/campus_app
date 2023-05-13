import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GroupCreateScreen extends StatefulWidget {
  final String email;

  const GroupCreateScreen({super.key, required this.email});

  @override
  State<GroupCreateScreen> createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends State<GroupCreateScreen> {
  TextEditingController groupNameController = TextEditingController();
  bool picked = false;
  late File pickedFile;

  Future selectFiles() async {
    final result =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (result == null) {
      setState(() {
        picked = false;
      });
      return;
    }
    final path = result.path;
    setState(() {
      pickedFile = File(path);
      picked = true;
    });
  }

  uploadDataToFirebase() async {
    File result = pickedFile;
    File pick = File(result!.path.toString());
    var file = pick.readAsBytesSync();

    //uploading
    var pdfFile = FirebaseStorage.instance
        .ref()
        .child("Images")
        .child(groupNameController.text.trim());
    UploadTask task = pdfFile.putData(file);
    task.whenComplete(() {
      pdfFile.getDownloadURL().then((value) => {
            FirebaseFirestore.instance
                .collection("GroupMessages")
                .doc(groupNameController.text.trim())
                .set({
              'imgUrl': value,
            }, SetOptions(merge: true))
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.create_outlined),
        onPressed: () {
          if (groupNameController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Group Name Should Not Empty'),
            ));
          } else if (!picked) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please select the Profile Photo'),
            ));
          } else {
            uploadDataToFirebase();
            FirebaseFirestore.instance
                .collection("GroupMessages")
                .doc(groupNameController.text.trim())
                .get()
                .then((doc) => {
                      if (doc.exists)
                        {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Group Already Present'),
                          ))
                        }
                      else
                        {
                          FirebaseFirestore.instance
                              .collection("GroupMessages")
                              .doc(groupNameController.text.trim())
                              .set({
                            'imgUrl': '',
                            'admins': FieldValue.arrayUnion([widget.email]),
                            'users': FieldValue.arrayUnion([widget.email]),
                            'groupName': groupNameController.text.trim(),
                            'isGroup': true,
                            'messageText': '',
                            'latestMessageBy': '',
                            'time': DateTime.now(),
                            'isMessageRead': true
                          }),
                          Navigator.pop(context)
                        }
                    });
          }
        },
      ),
      appBar: AppBar(
        title: const Text('Create Group'),
        backgroundColor: Colors.indigo[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: picked
                        ? Image.file(
                            pickedFile,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Image.asset(
                            "assets/images/profile.gif",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: -140,
                  bottom: -175,
                  child: IconButton(
                    onPressed: () {
                      selectFiles();
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin:
                  const EdgeInsetsDirectional.only(start: 10, end: 10, top: 30),
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo.shade300),
                      borderRadius: BorderRadius.circular(20)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Group Name',
                ),
                controller: groupNameController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
