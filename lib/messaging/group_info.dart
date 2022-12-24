import 'package:campus_subsystem/messaging/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/reducer.dart';

class GroupInfo extends StatelessWidget {
  final dynamic groupName;
  final dynamic imgUrl;
  final dynamic isFaculty;
  final dynamic users;
  const GroupInfo(
      {Key? key,
      required this.groupName,
      required this.isFaculty,
      required this.imgUrl,
      required this.users})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = StoreProvider.of<AppState>(context).state;

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
                      tag: "dp",
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(imgUrl),
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
                                email: x['Email'],
                                prn: x['PRN'],
                                status: x['status'],
                                isFaculty: isFaculty,
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
