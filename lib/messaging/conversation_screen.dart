import 'package:campus_subsystem/messaging/conversations.dart';
import 'package:campus_subsystem/messaging/new_message_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';

class ConversationScreen extends HookWidget {
  final bool isFaculty;
  const ConversationScreen({Key? key, required this.isFaculty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = StoreProvider.of<AppState>(context).state;
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
                              isFaculty: isFaculty,
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
                          stream: isFaculty
                              ? FirebaseFirestore.instance
                                  .collection(
                                      "Faculty_Detail/${data.email}/Messages")
                                  .orderBy('time')
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection(
                                      "Student_Detail/${data.prn}/Messages")
                                  .orderBy('time')
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
                                      prn: x['prn'],
                                      isFaculty: isFaculty,
                                    );
                                  });
                            } else {
                              return const SizedBox();
                            }
                          }),
                    ),
                  ),
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
                              .where("users", arrayContains: data.email)
                              .orderBy('time')
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
                                      isFaculty: isFaculty,
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
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                          size: 50, color: Colors.red));
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
