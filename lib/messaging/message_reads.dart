import 'package:campus_subsystem/messaging/message.dart';
import 'package:campus_subsystem/messaging/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/reducer.dart';

class MessageReads extends StatelessWidget {
  final dynamic groupName;
  final dynamic messageType;
  final dynamic name;
  final dynamic text;
  final dynamic time;
  final dynamic messageId;
  final List facultyList;

  const MessageReads(
      {Key? key,
      required this.text,
      required this.groupName,
      required this.facultyList,
      required this.messageId,
      required this.name,
      required this.messageType,
      required this.time})
      : super(key: key);

  Stream<List<dynamic>> getReads() async* {
    List<dynamic> list = [];

    // listen to changes in the document
    Stream<DocumentSnapshot> snapshotStream = FirebaseFirestore.instance
        .doc("GroupMessages/$groupName/Messages/$messageId")
        .snapshots();

    // fetch initial data
    DocumentSnapshot value = await FirebaseFirestore.instance
        .doc("GroupMessages/$groupName/Messages/$messageId")
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
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        title: const Text("Message Info"),
      ),
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Message(
                        messageType: messageType,
                        text: text,
                        isCurrentUser: true,
                        name: name,
                        time: time),
                  ),
                  Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 50),
                          alignment: Alignment.centerLeft,
                          color: Colors.indigo[100],
                          width: double.infinity,
                          height: 50,
                          child: const Text(
                            "Seen by",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          )),
                      StreamBuilder<List>(
                          stream: getReads(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        snapshot.data![index];
                                    return Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: User(
                                        storeData: state,
                                        imageUrl: data['imgUrl'],
                                        name: data['Name'],
                                        branch: data['Branch'],
                                        admins: const [],
                                        facultyList: facultyList,
                                        EmailR: data['Email'],
                                        year: data['Year'],
                                      ),
                                    );
                                  });
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          })
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
