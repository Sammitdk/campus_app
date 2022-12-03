import 'package:campus_subsystem/messaging/conversations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';

class ConversationScreen extends HookWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.pink,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Add New",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("GroupMessages")
                    .where("users", arrayContains: store.state.email)
                    .orderBy('time')
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          QueryDocumentSnapshot x = snapshot.data!.docs[index];
                          return ConversationList(
                            name: x['groupName'],
                            messageText: x['messageText'],
                            imageUrl: x['imgUrl'],
                            time: DateFormat('hh:mm a')
                                .format(x['time'].toDate())
                                .toString(),
                            isMessageRead: x['isMessageRead'],
                            latestMessageBy: x['latestMessageBy'],
                            count: 0,
                          );
                        });
                  } else {
                    return Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                            size: 50, color: Colors.red));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
