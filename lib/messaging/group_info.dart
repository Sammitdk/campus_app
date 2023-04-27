import 'package:cached_network_image/cached_network_image.dart';
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
                        placeholder: (context, url) =>
                        const CircleAvatar(
                          backgroundImage: AssetImage(
                              "assets/images/profile.gif"),
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
                        fontFamily: 'Narrow', fontSize: 23,color: Colors.black),
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
                    onPressed: () {},
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
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("Student_Detail")
                        .where("Email", whereIn: users)
                        .orderBy("Name.First")
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, i) {
                              QueryDocumentSnapshot x = snapshot.data!.docs[i];
                              return User(
                                imageUrl: x['imgUrl'],
                                name: x['Name'],
                                branch: x['Branch'],
                                year: x['Year'],
                                EmailR: x['PRN'],
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
