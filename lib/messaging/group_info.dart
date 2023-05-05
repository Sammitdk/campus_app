import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_subsystem/messaging/group_addmembers.dart';
import 'package:campus_subsystem/messaging/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatelessWidget {
  final dynamic groupName;
  final dynamic imgUrl;
  final dynamic users;
  final dynamic data;

  const GroupInfo(
      {Key? key,
      required this.data,
      required this.groupName,
      required this.imgUrl,
      required this.users})
      : super(key: key);

  Stream<List<dynamic>> getInfoStream() async* {
    List<dynamic> list = [];

    // listen to changes in the document
    Stream<DocumentSnapshot> snapshotStream =
    FirebaseFirestore.instance.doc("GroupMessages/$groupName").snapshots();

    // fetch initial data
    DocumentSnapshot value = await FirebaseFirestore.instance
        .doc("GroupMessages/$groupName")
        .get();
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


  @override
  Widget build(BuildContext context) {
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
                            const Icon(Icons.error),
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
                      getInfoStream();
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddToGroup(
                                      data: data,
                                      users: users,
                                      groupName: groupName,
                                    )));
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
                              return User(
                                imageUrl: x['imgUrl'],
                                name: x['Name'],
                                branch: x['Branch'],
                                year: x['Year'],
                                EmailR: x['Email'],
                                storeData: data,
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
