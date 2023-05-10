import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_subsystem/main.dart';
import 'package:campus_subsystem/messaging/group_addmembers.dart';
import 'package:campus_subsystem/messaging/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GroupInfo extends HookWidget {
  final dynamic groupName;
  final dynamic imgUrl;
  final dynamic users;
  final dynamic data;
  final dynamic facultyList;

  const GroupInfo(
      {Key? key,
      required this.data,
      required this.groupName,
      required this.imgUrl,
      this.facultyList,
      required this.users})
      : super(key: key);

  Stream<List<dynamic>> getInfoStream() async* {
    List<dynamic> list = [];

    // listen to changes in the document
    Stream<DocumentSnapshot> snapshotStream =
        FirebaseFirestore.instance.doc("GroupMessages/$groupName").snapshots();

    // fetch initial data
    DocumentSnapshot value =
        await FirebaseFirestore.instance.doc("GroupMessages/$groupName").get();
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
    DocumentSnapshot value = await FirebaseFirestore.instance
        .collection("GroupMessages")
        .doc(groupName)
        .get();
    Map<String, dynamic> temp = value.data() as Map<String, dynamic>;
    return temp['admins'];
  }

  @override
  Widget build(BuildContext context) {
    var admins = useState([]);
    useEffect(() {
      getAdmins().then((value) {
        admins.value = value;
      });
      return null;
    }, []);
    return Scaffold(
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 100,
                          );
                        },
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profile.gif"),
                          maxRadius: 30,
                        ),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profile.gif"),
                          maxRadius: 30,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    groupName,
                    style: const TextStyle(
                        fontFamily: 'Narrow',
                        fontSize: 23,
                        color: Colors.black),
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
                        FirebaseFirestore.instance
                            .collection("GroupMessages")
                            .doc(groupName)
                            .update({
                          "users": FieldValue.arrayRemove([data.email]),
                        });
                        FirebaseFirestore.instance
                            .collection("GroupMessages/$groupName/Messages")
                            .add(
                          {
                            "messageType": "left",
                            "email": data.email,
                            "name": data.name['First'],
                            "time": Timestamp.now(),
                            "users": FieldValue.arrayUnion([data.email]),
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
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green[400])),
                    onPressed: () {
                      if (admins.value.contains(data.email)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddToGroup(
                                      data: data,
                                      groupName: groupName,
                                      users: users,
                                    )));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
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
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, i) {
                              Map<String, dynamic> x = snapshot.data![i];
                              return GestureDetector(
                                onLongPress: () {
                                  if (admins.value.contains(data.email) &&
                                      x['Email'] != data.email) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding:
                                              const EdgeInsets.all(16.0),
                                          buttonPadding: EdgeInsets.zero,
                                          elevation: 0,
                                          insetPadding: const EdgeInsets.only(
                                              right: 10, left: 180),
                                          actions: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        x['Name']['First']
                                                            .toString()
                                                            .capitalize(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                TextButton(
                                                  child: const Text('Remove'),
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "GroupMessages")
                                                        .doc(groupName)
                                                        .update({
                                                      "users": FieldValue
                                                          .arrayRemove(
                                                              [x['Email']]),
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "GroupMessages/$groupName/Messages")
                                                        .add(
                                                      {
                                                        "messageType": "left",
                                                        "email": data.email,
                                                        "name": x['Name']
                                                            ['First'],
                                                        "time": Timestamp.now(),
                                                        "users": FieldValue
                                                            .arrayUnion(
                                                                [data.email]),
                                                        "message":
                                                            data.name['First']
                                                      },
                                                    );
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                ),
                                                (!admins.value
                                                        .contains(x['Email']))
                                                    ? TextButton(
                                                        child: const Text(
                                                            'Make Admin'),
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "GroupMessages")
                                                              .doc(groupName)
                                                              .update({
                                                            "admins": FieldValue
                                                                .arrayUnion([
                                                              x['Email']
                                                            ]),
                                                          });
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "GroupMessages/$groupName/Messages")
                                                              .add({
                                                            "messageType":
                                                                "adminAdded",
                                                            "email": data.email,
                                                            "name": data
                                                                .name['First'],
                                                            "time":
                                                                Timestamp.now(),
                                                            "users": FieldValue
                                                                .arrayUnion([
                                                              data.email
                                                            ]),
                                                            "message": x['Name']
                                                                ['First'],
                                                          });
                                                          admins.value
                                                              .add(x['Email']);
                                                          Navigator.pop(
                                                              context, false);
                                                        },
                                                      )
                                                    : TextButton(
                                                        child: const Text(
                                                            'Remove Admin'),
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "GroupMessages")
                                                              .doc(groupName)
                                                              .update({
                                                            "admins": FieldValue
                                                                .arrayRemove([
                                                              x['Email']
                                                            ]),
                                                          });
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "GroupMessages/$groupName/Messages")
                                                              .add({
                                                            "messageType":
                                                                "adminRemoved",
                                                            "email": data.email,
                                                            "name": data
                                                                .name['First'],
                                                            "time":
                                                                Timestamp.now(),
                                                            "users": FieldValue
                                                                .arrayUnion([
                                                              data.email
                                                            ]),
                                                            "message": x['Name']
                                                                ['First'],
                                                          });
                                                          admins.value.remove(
                                                              x['Email']);
                                                          Navigator.pop(
                                                              context, false);
                                                        },
                                                      ),
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.pop(context,
                                                        false); // Return false when cancel is pressed
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
                                  storeData: data,
                                  facultyList: facultyList,
                                  admins: admins.value,
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
