import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_subsystem/main.dart';
import 'package:campus_subsystem/messaging/group_addmembers.dart';
import 'package:campus_subsystem/messaging/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GroupInfo extends StatefulWidget {
  final dynamic groupName;
  String imgUrl;
  final dynamic users;
  final dynamic data;
  final dynamic facultyList;

  GroupInfo({Key? key, required this.data, required this.groupName, required this.imgUrl, this.facultyList, required this.users})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  List admins = [];

  @override
  void initState() {
    super.initState();
    getAdmins().then((value) {
      setState(() {
        admins = value;
      });
    });
  }

  Stream<List<dynamic>> getInfoStream() async* {
    List<dynamic> list = [];

    // listen to changes in the document
    Stream<DocumentSnapshot> snapshotStream = FirebaseFirestore.instance.doc("GroupMessages/${widget.groupName}").snapshots();

    // fetch initial data
    DocumentSnapshot value = await FirebaseFirestore.instance.doc("GroupMessages/${widget.groupName}").get();
    Map<String, dynamic> temp = value.data() as Map<String, dynamic>;
    QuerySnapshot<Map<String, dynamic>> ans = await FirebaseFirestore.instance
        .collection("Faculty_Detail")
        .where("Email", whereIn: temp['users'])
        .orderBy("Name.First")
        .get();
    for (var element in ans.docs) {
      list.add(element.data());
    }

    ans = await FirebaseFirestore.instance
        .collection("Student_Detail")
        .where("Email", whereIn: temp['users'])
        .orderBy("Name.First")
        .get();
    for (var element in ans.docs) {
      list.add(element.data());
    }

    yield list;

    // listen to changes in the document and update the list accordingly
    await for (DocumentSnapshot snapshot in snapshotStream) {
      Map<String, dynamic> temp = snapshot.data() as Map<String, dynamic>;
      QuerySnapshot<Map<String, dynamic>> ans = await FirebaseFirestore.instance
          .collection("Faculty_Detail")
          .where("Email", whereIn: temp['users'])
          .orderBy("Name.First")
          .get();
      list = [];
      for (var element in ans.docs) {
        list.add(element.data());
      }

      ans = await FirebaseFirestore.instance
          .collection("Student_Detail")
          .where("Email", whereIn: temp['users'])
          .orderBy("Name.First")
          .get();
      for (var element in ans.docs) {
        list.add(element.data());
      }
      yield list;
    }
  }

  Future<List<dynamic>> getAdmins() async {
    DocumentSnapshot value = await FirebaseFirestore.instance.collection("GroupMessages").doc(widget.groupName).get();
    Map<String, dynamic> temp = value.data() as Map<String, dynamic>;
    return temp['admins'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  primary: false,
                  floating: true,
                  snap: true,
                  // stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Hero(
                      tag: "group",
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
                          if (picked == null) {
                            return;
                          }
                          final path = picked.path;
                          File result = File(path);
                          File pick = File(result.path.toString());
                          var file = pick.readAsBytesSync();
                          //uploading
                          var pdfFile = FirebaseStorage.instance.ref().child("Images").child(widget.groupName);
                          UploadTask task = pdfFile.putData(file);
                          task.whenComplete(() {
                            pdfFile.getDownloadURL().then((value) {
                              setState(() {
                                widget.imgUrl = value;
                              });
                              FirebaseFirestore.instance.collection("GroupMessages").doc(widget.groupName).set({
                                'imgUrl': value,
                              }, SetOptions(merge: true));
                            });
                          });
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.imgUrl,
                          imageBuilder: (context, imageProvider) {
                            return CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 100,
                            );
                          },
                          placeholder: (context, url) => const CircleAvatar(
                            backgroundImage: AssetImage("assets/images/profile.gif"),
                            maxRadius: 30,
                          ),
                          errorWidget: (context, url, error) => const CircleAvatar(
                            backgroundImage: AssetImage("assets/images/profile.gif"),
                            maxRadius: 30,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.groupName,
                    style: const TextStyle(fontFamily: 'Narrow', fontSize: 23, color: Colors.black),
                  ),
                  expandedHeight: 250,
                  backgroundColor: Colors.white,
                  actions: [
                    PopupMenuButton(itemBuilder: (context) {
                      return [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Text("Search Members"),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: Text("Leave Group"),
                        ),
                      ];
                    }, onSelected: (value) {
                      if (value == 0) {
                      } else if (value == 1) {
                        FirebaseFirestore.instance.collection("GroupMessages").doc(widget.groupName).update({
                          "users": FieldValue.arrayRemove([widget.data.email]),
                        });
                        FirebaseFirestore.instance.collection("GroupMessages/${widget.groupName}/Messages").add(
                          {
                            "messageType": "left",
                            "email": widget.data.email,
                            "name": widget.data.name['First'],
                            "time": Timestamp.now(),
                            "users": FieldValue.arrayUnion([widget.data.email]),
                            "message": ""
                          },
                        );
                        Navigator.pop(context);
                      }
                    })
                  ],
                )
              ];
            },
            body: Column(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green[400])),
                    onPressed: () {
                      print(widget.data.email);
                      if (admins.contains(widget.data.email)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddToGroup(
                                      data: widget.data,
                                      groupName: widget.groupName,
                                      users: widget.users,
                                    )));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            duration: Duration(milliseconds: 500),
                            backgroundColor: Colors.black,
                            content: Text(
                              "Only admins can add",
                              style: TextStyle(color: Colors.white),
                            )));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(Icons.add),
                        ),
                        Text("Add Members"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: StreamBuilder<List<dynamic>>(
                    stream: getInfoStream(),
                    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, i) {
                              Map<String, dynamic> x = snapshot.data![i];
                              return GestureDetector(
                                onLongPress: () {
                                  if (admins.contains(widget.data.email) && x['Email'] != widget.data.email) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding: const EdgeInsets.all(16.0),
                                          buttonPadding: EdgeInsets.zero,
                                          elevation: 0,
                                          insetPadding: const EdgeInsets.only(right: 10, left: 180),
                                          actions: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        x['Name']['First'].toString().capitalize(),
                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    )),
                                                TextButton(
                                                  child: const Text('Remove'),
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection("GroupMessages")
                                                        .doc(widget.groupName)
                                                        .update({
                                                      "users": FieldValue.arrayRemove([x['Email']]),
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection("GroupMessages/${widget.groupName}/Messages")
                                                        .add(
                                                      {
                                                        "messageType": "left",
                                                        "email": widget.data.email,
                                                        "name": x['Name']['First'],
                                                        "time": Timestamp.now(),
                                                        "users": FieldValue.arrayUnion([widget.data.email]),
                                                        "message": widget.data.name['First']
                                                      },
                                                    );
                                                    Navigator.pop(context, false);
                                                  },
                                                ),
                                                (!admins.contains(x['Email']))
                                                    ? TextButton(
                                                        child: const Text('Make Admin'),
                                                        onPressed: () {
                                                          FirebaseFirestore.instance
                                                              .collection("GroupMessages")
                                                              .doc(widget.groupName)
                                                              .update({
                                                            "admins": FieldValue.arrayUnion([x['Email']]),
                                                          });
                                                          FirebaseFirestore.instance
                                                              .collection("GroupMessages/${widget.groupName}/Messages")
                                                              .add({
                                                            "messageType": "adminAdded",
                                                            "email": widget.data.email,
                                                            "name": widget.data.name['First'],
                                                            "time": Timestamp.now(),
                                                            "users": FieldValue.arrayUnion([widget.data.email]),
                                                            "message": x['Name']['First'],
                                                          });
                                                          admins.add(x['Email']);
                                                          Navigator.pop(context, false);
                                                        },
                                                      )
                                                    : TextButton(
                                                        child: const Text('Remove Admin'),
                                                        onPressed: () {
                                                          FirebaseFirestore.instance
                                                              .collection("GroupMessages")
                                                              .doc(widget.groupName)
                                                              .update({
                                                            "admins": FieldValue.arrayRemove([x['Email']]),
                                                          });
                                                          FirebaseFirestore.instance
                                                              .collection("GroupMessages/${widget.groupName}/Messages")
                                                              .add({
                                                            "messageType": "adminRemoved",
                                                            "email": widget.data.email,
                                                            "name": widget.data.name['First'],
                                                            "time": Timestamp.now(),
                                                            "users": FieldValue.arrayUnion([widget.data.email]),
                                                            "message": x['Name']['First'],
                                                          });
                                                          admins.remove(x['Email']);
                                                          Navigator.pop(context, false);
                                                        },
                                                      ),
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.pop(context, false); // Return false when cancel is pressed
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: User(
                                  imageUrl: x['imgUrl'],
                                  name: x['Name'],
                                  branch: x['Branch'],
                                  year: x['Year'],
                                  EmailR: x['Email'],
                                  storeData: widget.data,
                                  facultyList: widget.facultyList,
                                  admins: admins,
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            )));
  }
}
