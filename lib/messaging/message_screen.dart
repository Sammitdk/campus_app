import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_subsystem/messaging/group_info.dart';
import 'package:campus_subsystem/messaging/read_message-fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'message.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';

class MessageScreen extends HookWidget {
  final dynamic groupName;
  final dynamic imageUrl;
  final dynamic isGroup;
  final dynamic EmailR;
  final dynamic status;
  final dynamic users;
  final dynamic data;

  const MessageScreen({
    Key? key,
    this.users,
    this.status,
    this.EmailR,
    required this.data,
    required this.isGroup,
    required this.groupName,
    required this.imageUrl,
  }) : super(key: key);

  static TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    var bottom = useState(60.0);
    var isReverse = useState(true);

    dynamic stream = isGroup
        ? FirebaseFirestore.instance
            .collection("GroupMessages/$groupName/Messages")
            .orderBy('time', descending: true)
            .snapshots(includeMetadataChanges: true)
        : FirebaseFirestore.instance
            .collection("Messages/${data.email}/Messages/$EmailR/Messages")
            .orderBy('time', descending: true)
            .snapshots(includeMetadataChanges: true);

    useEffect(() {
      StreamSubscription messageStream = stream.listen((event) {
        if (isGroup) {
          readAll(
            groupName: groupName,
            data: data,
            isGroup: true,
          );
        } else {
          readAll(isGroup: false, groupName: EmailR, data: data);
        }
      });

      return () {
        messageStream.cancel();
        scrollController.dispose();
      };
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: isGroup
          ? AppBar(
              actions: [
                PopupMenuButton(itemBuilder: (context) {
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => GroupInfo(
                                  users: users,
                                  imgUrl: imageUrl,
                                  groupName: groupName,
                                  data: data,
                                )));
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
              ],
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              automaticallyImplyLeading: false,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => GroupInfo(
                                      users: users,
                                      imgUrl: imageUrl,
                                      groupName: groupName,
                                      data: data,
                                    )));
                      },
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        imageBuilder: (context, imageProvider) {
                          return Hero(
                            tag: "group",
                            child: CircleAvatar(
                              backgroundImage: imageProvider,
                              maxRadius: 25,
                            ),
                          );
                        },
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage("assets/images/profile.gif"),
                          maxRadius: 30,
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 30,
                          child: Image.asset("assets/images/profile.gif"),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: Text(
                      groupName,
                      style:
                          const TextStyle(fontFamily: 'Narrow', fontSize: 23),
                    ),
                  ),
                ],
              ),
            )
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          backgroundImage: imageProvider,
                          maxRadius: 25,
                        );
                      },
                      placeholder: (context, url) => const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            AssetImage("assets/images/profile.gif"),
                        maxRadius: 30,
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 30,
                        child: Image.asset("assets/images/profile.gif"),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupName,
                        style:
                            const TextStyle(fontFamily: 'Narrow', fontSize: 23),
                        textAlign: TextAlign.center,
                      ),
                      Text(status,
                          style: TextStyle(
                              fontSize: 15,
                              color: status == "Online"
                                  ? Colors.green
                                  : Colors.red[500]))
                    ],
                  ),
                ],
              )),
      body: KeyboardVisibility(
        onChanged: (isOpened) {
          if (isOpened) {
            bottom.value = 350.0;
            scrollController.animateTo(0,
                duration: const Duration(milliseconds: 1),
                curve: Curves.easeInOut);
          } else {
            bottom.value = 60.0;
          }
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: bottom.value,
              top: 20,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: StreamBuilder(
                    stream: stream,
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          controller: scrollController,
                          reverse: isReverse.value,
                          shrinkWrap: true,
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
                          },
                        );
                      } else {
                        return const SizedBox();
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
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 1),
                                curve: Curves.easeInOut);
                          },
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

                              // notification to all users
                              // FirebaseFirestore.instance
                              //     .doc("GroupMessages/$groupName")
                              //     .get()
                              //     .then((value) {
                              //   Map group = value.data() as Map;
                              //   if (group.containsKey("users")) {
                              //     group["users"].forEach((user) {
                              //       if (user != data.email) {
                              //         FirebaseFirestore.instance
                              //             .collection("Student_Detail")
                              //             .where("Email", isEqualTo: user)
                              //             .get()
                              //             .then((userdocs) {
                              //           if (userdocs.docs[0]
                              //               .data()
                              //               .containsKey("Token")) {
                              //             NotificationAPI.postNotification(
                              //                 title: groupName,
                              //                 message:
                              //                 "  ${data.name["First"].toString().capitalize()}: ${myController.text}",
                              //                 receiver: userdocs.docs[0]
                              //                 ["Token"]);
                              //           }
                              //         });
                              //       }
                              //     });
                              //   }
                              // });
                              myController.clear();
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
                                      "Messages/${data.email}/Messages/$EmailR/Messages")
                                  .add(firebaseUserData);

                              // last message info
                              FirebaseFirestore.instance
                                  .collection("Messages/${data.email}/Messages")
                                  .doc(EmailR)
                                  .update({
                                "messageText": myController.text,
                                "time": Timestamp.now(),
                              });

                              // receiver user
                              FirebaseFirestore.instance
                                  .collection(
                                      "Messages/$EmailR/Messages/${data.email}/Messages")
                                  .add(firebaseUserData);

                              // last message info
                              FirebaseFirestore.instance
                                  .collection("Messages/$EmailR/Messages")
                                  .doc(data.email)
                                  .update({
                                "messageText": myController.text,
                                "time": Timestamp.now(),
                              });

                              // notification to receiver
                              // String receiver = await FirebaseFirestore
                              //     .instance
                              //     .doc("Student_Detail/$EmailR")
                              //     .get()
                              //     .then((value) {
                              //   {
                              //     Map user = value.data() as Map;
                              //     if (user.containsKey("Token")) {
                              //       return user["Token"];
                              //     }
                              //     return '';
                              //   }
                              // });
                              //
                              // receiver.isNotEmpty
                              //     ? NotificationAPI.postNotification(
                              //     title:
                              //     "${data.name['First'].toString().capitalize()} ${data.name['Last'].toString().capitalize()}",
                              //     message: myController.text,
                              //     receiver: receiver)
                              //     : null;
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
