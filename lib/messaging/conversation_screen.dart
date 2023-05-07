import 'package:campus_subsystem/messaging/conversations.dart';
import 'package:campus_subsystem/messaging/new_message_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key, required bool isFaculty})
      : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<dynamic> facultyList = [];

  void faculty() async {
    List list = [];
    await FirebaseFirestore.instance
        .collection("Faculty_Detail")
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                Map<String, dynamic> data = element.data();
                list.add(data['Email']);
              })
            });
    setState(() {
      facultyList = list;
    });
  }

  @override
  void initState() {
    super.initState();
    faculty();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
              floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: const Icon(Icons.messenger_outline_outlined),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NewMessage(
                                  facultyList: facultyList,
                                  data: state,
                                )));
                  }),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                title: const TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.green,
                  tabs: [
                    Text(
                      "Chat",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      "Groups",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 10,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        child: SingleChildScrollView(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(
                                      "Messages/${state.email}/Messages")
                                  .orderBy('time', descending: true)
                                  .snapshots(),
                              builder:
                                  (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (ctx, index) {
                                        QueryDocumentSnapshot x =
                                            snapshot.data!.docs[index];
                                        return ConversationList(
                                          name: x['groupName'],
                                          messageText: x['messageText'],
                                          time: DateFormat('hh:mm a')
                                              .format(x['time'].toDate())
                                              .toString(),
                                          isMessageRead: x['isMessageRead'],
                                          latestMessageBy: "ok",
                                          count: 0,
                                          isGroup: x["isGroup"],
                                          EmailR: x['email'],
                                          imageUrl: x["imgUrl"],
                                          facultyList: facultyList,
                                        );
                                      });
                                } else {
                                  return const SizedBox();
                                }
                              }),
                        ),
                      ),
                      // Positioned(
                      //   bottom: 10,
                      //   left: 0,
                      //   right: 0,
                      //   child: Padding(
                      //     padding:
                      //         const EdgeInsets.only(top: 16, left: 16, right: 16),
                      //     child: TextField(
                      //       decoration: InputDecoration(
                      //         hintText: "Search...",
                      //         hintStyle: TextStyle(color: Colors.grey.shade600),
                      //         prefixIcon: Icon(
                      //           Icons.search,
                      //           color: Colors.grey.shade600,
                      //           size: 20,
                      //         ),
                      //         filled: true,
                      //         fillColor: Colors.grey.shade100,
                      //         contentPadding: const EdgeInsets.all(8),
                      //         enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(20),
                      //             borderSide:
                      //                 BorderSide(color: Colors.grey.shade100)),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 10,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        child: SingleChildScrollView(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("GroupMessages")
                                  .where("users", arrayContains: state.email)
                                  .orderBy('time', descending: true)
                                  .snapshots(),
                              builder:
                                  (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (ctx, index) {
                                        QueryDocumentSnapshot x =
                                            snapshot.data!.docs[index];
                                        return ConversationList(
                                          facultyList: facultyList,
                                          users: x['users'],
                                          name: x['groupName'],
                                          messageText: x['messageText'],
                                          imageUrl: x['imgUrl'],
                                          time: DateFormat('hh:mm a')
                                              .format(x['time'].toDate())
                                              .toString(),
                                          isMessageRead: x['isMessageRead'],
                                          latestMessageBy: x['latestMessageBy'],
                                          isGroup: x["isGroup"],
                                          count: 0,
                                        );
                                      });
                                } else {
                                  return Center(
                                      child: LoadingAnimationWidget
                                          .staggeredDotsWave(
                                              size: 50, color: Colors.red));
                                }
                              }),
                        ),
                      ),
                      // Positioned(
                      //   bottom: 10,
                      //   left: 0,
                      //   right: 0,
                      //   child: Padding(
                      //     padding:
                      //         const EdgeInsets.only(top: 16, left: 16, right: 16),
                      //     child: TextField(
                      //       decoration: InputDecoration(
                      //         hintText: "Search...",
                      //         hintStyle: TextStyle(color: Colors.grey.shade600),
                      //         prefixIcon: Icon(
                      //           Icons.search,
                      //           color: Colors.grey.shade600,
                      //           size: 20,
                      //         ),
                      //         filled: true,
                      //         fillColor: Colors.grey.shade100,
                      //         contentPadding: const EdgeInsets.all(8),
                      //         enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(20),
                      //             borderSide:
                      //                 BorderSide(color: Colors.grey.shade100)),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }
}
