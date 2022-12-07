import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_subsystem/firebase/notification.dart';
import 'package:campus_subsystem/main.dart';
import 'package:campus_subsystem/messaging/read_message-fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';
import 'message.dart';

class MessageScreen extends HookWidget {
  final dynamic groupName;
  final dynamic imageUrl;
  final dynamic isGroup;
  final dynamic prn;

  const MessageScreen({
    Key? key,
    this.prn,
    required this.isGroup,
    required this.groupName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    var data = StoreProvider.of<AppState>(context).state;
    ScrollController scrollController = ScrollController();
    void goDown() async {
      await Future.delayed(const Duration(milliseconds: 700)).then((value) => {
            if (scrollController.hasClients)
              {
                scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.easeInOut)
              }
          });
    }

    ScrollController scroll = ScrollController();
    var groupInfo = useState(false);
    dynamic stream = isGroup
        ? FirebaseFirestore.instance
            .collection("GroupMessages/$groupName/Messages")
            .orderBy('time')
            .snapshots()
        : FirebaseFirestore.instance
            .collection("Student_Detail/${data.prn}/Messages/$prn/Messages")
            .orderBy('time')
            .snapshots(includeMetadataChanges: true);

    dynamic onlineStream = FirebaseFirestore.instance
        .collection("Student_Detail")
        .doc(prn)
        .snapshots();

    useEffect(() {
      stream.listen((event) {
        if (isGroup) {
          readAll(
            groupName: groupName,
            data: data,
            isGroup: true,
          );
        } else {
          readAll(isGroup: false, groupName: prn, data: data);
        }
      });
      goDown();
      return () {
        stream;
        onlineStream;
      };
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: scroll,
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: groupInfo.value ? false : false,
              flexibleSpace: groupInfo.value
                  ? FlexibleSpaceBar(
                      background: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        groupName,
                        style:
                            const TextStyle(fontFamily: 'Narrow', fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      title: StreamBuilder(
                          stream: onlineStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              dynamic s = snapshot.data;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8),
                                    child: CachedNetworkImage(
                                      imageUrl: s['imgUrl'],
                                      imageBuilder: (context, imageProvider) {
                                        return CircleAvatar(
                                          backgroundImage: imageProvider,
                                          maxRadius: 25,
                                        );
                                      },
                                      placeholder: (context, url) =>
                                          const CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: AssetImage(
                                            "assets/images/profile.gif"),
                                        maxRadius: 30,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 30,
                                        child: Image.asset(
                                            "assets/images/profile.gif"),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        groupName,
                                        style: const TextStyle(
                                            fontFamily: 'Narrow', fontSize: 23),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(s["status"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: s["status"] == "Online"
                                                  ? Colors.green
                                                  : Colors.red[500]))
                                    ],
                                  ),
                                ],
                              );
                            }
                            return const CircularProgressIndicator();
                          }),
                    ),
              expandedHeight: groupInfo.value ? 150 : 50,
              backgroundColor: Colors.indigo[300],
              actions: [
                isGroup
                    ? PopupMenuButton(itemBuilder: (context) {
                        return [
                          const PopupMenuItem<int>(
                            value: 0,
                            child: Text("Group Info"),
                          ),
                          const PopupMenuItem<int>(
                            value: 1,
                            child: Text("Search"),
                          ),
                          const PopupMenuItem<int>(
                            value: 2,
                            child: Text("Leave Group"),
                          ),
                        ];
                      }, onSelected: (value) {
                        if (value == 0) {
                          groupInfo.value = true;
                        } else if (value == 1) {
                        } else if (value == 2) {
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
                    : const SizedBox(),
              ],
              floating: true,
              pinned: true,
              snap: true,
              stretch: true,
            )
          ];
        },
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 60,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: StreamBuilder(
                    stream: stream,
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (ctx, index) {
                              QueryDocumentSnapshot x =
                                  snapshot.data!.docs[index];
                              return Message(
                                text: x['message'],
                                name: x['name'],
                                messageType: x['messageType'],
                                isCurrentUser: x['email'] == data.email,
                                time: DateFormat('hh:mm a')
                                    .format(x['time'].toDate())
                                    .toString(),
                              );
                            });
                      } else {
                        return Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                size: 50, color: Colors.red));
                      }
                    }),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 1),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (v) {},
                          controller: myController,
                          decoration: const InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          if (myController.text.isNotEmpty) {
                            if (isGroup) {
                              // for group message
                              final firebaseData = {
                                "name": data.name['First'],
                                "time": Timestamp.now(),
                                "email": data.email,
                                "message": myController.text,
                                "users": [data.email],
                                "messageType": "groupMessage"
                              };

                              // new message to group
                              FirebaseFirestore.instance
                                  .collection(
                                      "GroupMessages/$groupName/Messages")
                                  .add(firebaseData);

                              // last message user info
                              FirebaseFirestore.instance
                                  .collection("GroupMessages")
                                  .doc(groupName)
                                  .update({
                                "messageText": myController.text,
                                "time": Timestamp.now(),
                                "latestMessageBy": data.name['First']
                              });

                              FirebaseFirestore.instance
                                  .doc("GroupMessages/$groupName")
                                  .get()
                                  .then((value) {
                                Map group = value.data() as Map;
                                if (group.containsKey("users")) {
                                  group["users"].forEach((user) {
                                    if (user != data.email) {
                                      FirebaseFirestore.instance
                                          .collection("Student_Detail")
                                          .where("Email", isEqualTo: user)
                                          .get()
                                          .then((userdocs) {
                                        if (userdocs.docs[0]
                                            .data()
                                            .containsKey("Token")) {
                                          NotificationAPI.postNotification(
                                              title: groupName,
                                              message:
                                                  "  ${data.name["First"].toString().capitalize()}: ${myController.text}",
                                              receiver: userdocs.docs[0]
                                                  ["Token"]);
                                        }
                                      });
                                    }
                                  });
                                }
                              });
                            } else {
                              // for user message
                              final firebaseUserData = {
                                "name": data.name['First'],
                                "time": Timestamp.now(),
                                "email": data.email,
                                "message": myController.text,
                                "messageType": "userMessage",
                                "users": [data.email],
                              };

                              // sender user
                              FirebaseFirestore.instance
                                  .collection(
                                      "Student_Detail/${data.prn}/Messages/$prn/Messages")
                                  .add(firebaseUserData);

                              // last message info
                              FirebaseFirestore.instance
                                  .collection(
                                      "Student_Detail/${data.prn}/Messages")
                                  .doc(prn)
                                  .update({
                                "messageText": myController.text,
                                "time": Timestamp.now(),
                              });

                              // receiver user
                              FirebaseFirestore.instance
                                  .collection(
                                      "Student_Detail/$prn/Messages/${data.prn}/Messages")
                                  .add(firebaseUserData);

                              // last message info
                              FirebaseFirestore.instance
                                  .collection("Student_Detail/$prn/Messages")
                                  .doc(data.prn)
                                  .update({
                                "messageText": myController.text,
                                "time": Timestamp.now(),
                              });

                              // notification to receiver
                              String receiver = await FirebaseFirestore.instance
                                  .doc("Student_Detail/$prn")
                                  .get()
                                  .then((value) {
                                {
                                  Map user = value.data() as Map;
                                  if (user.containsKey("Token")) {
                                    return user["Token"];
                                  }
                                  return '';
                                }
                              });
                              receiver.isNotEmpty
                                  ? NotificationAPI.postNotification(
                                      title:
                                          "${data.name['First'].toString().capitalize()} ${data.name['Last'].toString().capitalize()}",
                                      message: myController.text,
                                      receiver: receiver)
                                  : null;
                            }
                          }
                          myController.clear();
                        },
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
