import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_subsystem/messaging/group_info.dart';
import 'package:campus_subsystem/messaging/read_message-fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'message.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';

class MessageScreen extends StatefulHookWidget {
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
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Set<String> set = {};

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    var bottom = useState(60.0);
    var isReverse = useState(true);
    var isDelete = useState(0);
    var copy = useState("");

    dynamic stream = widget.isGroup
        ? FirebaseFirestore.instance
            .collection("GroupMessages/${widget.groupName}/Messages")
            .orderBy('time', descending: true)
            .snapshots(includeMetadataChanges: true)
        : FirebaseFirestore.instance
            .collection(
                "Messages/${widget.data.email}/Messages/${widget.EmailR}/Messages")
            .orderBy('time', descending: true)
            .snapshots(includeMetadataChanges: true);

    useEffect(() {
      StreamSubscription messageStream = stream.listen((event) {
        if (widget.isGroup) {
          readAll(
            groupName: widget.groupName,
            data: widget.data,
            isGroup: true,
          );
        } else {
          readAll(isGroup: false, groupName: widget.EmailR, data: widget.data);
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
      appBar: widget.isGroup
          ? AppBar(
              actions: set.isEmpty
                  ? [
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
                                        users: widget.users,
                                        imgUrl: widget.imageUrl,
                                        groupName: widget.groupName,
                                        data: widget.data,
                                      )));
                        } else if (value == 1) {
                        } else if (value == 2) {
                          FirebaseFirestore.instance
                              .collection("GroupMessages")
                              .doc(widget.groupName)
                              .update({
                            "users":
                                FieldValue.arrayRemove([widget.data.email]),
                          });
                          FirebaseFirestore.instance
                              .collection(
                                  "GroupMessages/${widget.groupName}/Messages")
                              .add(
                            {
                              "messageType": "left",
                              "email": widget.data.email,
                              "name": widget.data.name['First'],
                              "time": Timestamp.now(),
                              "users":
                                  FieldValue.arrayUnion([widget.data.email]),
                              "message": ""
                            },
                          );
                          Navigator.pop(context);
                        }
                      })
                    ]
                  : [
                      Row(
                        children: [
                          Text(set.length.toString()),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_outlined),
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete messages'),
                                    content: (isDelete.value <= 0)
                                        ? const Text(
                                            'Are you sure you want to delete these messages?')
                                        : const Text(
                                            'You cant delete others messages please unselect them'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      (isDelete.value <= 0)
                                          ? TextButton(
                                              child: const Text(
                                                  'Delete For Everyone'),
                                              onPressed: () {
                                                for (var element in set) {
                                                  FirebaseFirestore.instance
                                                      .doc(
                                                          "GroupMessages/${widget.groupName}/Messages/$element")
                                                      .delete();
                                                }
                                                setState(() {
                                                  set.clear();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          : const SizedBox(),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          (set.length == 1)
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.copy,
                                      size: 19,
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: copy.value));
                                      isDelete.value = 0;
                                      setState(() {
                                        set.clear();
                                      });
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    ],
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              automaticallyImplyLeading: false,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  set.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            isDelete.value = 0;
                            setState(() {
                              set.clear();
                            });
                          },
                          icon: const Icon(Icons.arrow_back))
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => GroupInfo(
                                      users: widget.users,
                                      imgUrl: widget.imageUrl,
                                      groupName: widget.groupName,
                                      data: widget.data,
                                    )));
                      },
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
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
                      widget.groupName,
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
              actions: set.isNotEmpty
                  ? [
                      Row(
                        children: [
                          Text(set.length.toString()),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_outlined),
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete messages'),
                                    content: const Text(
                                        'Are you sure you want to delete these messages?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Delete For Me'),
                                        onPressed: () {
                                          for (var element in set) {
                                            FirebaseFirestore.instance
                                                .doc(
                                                    "Messages/${widget.data.email}/Messages/${widget.EmailR}/Messages/$element")
                                                .delete();
                                          }
                                          setState(() {
                                            set.clear();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      (isDelete.value <= 0)
                                          ? TextButton(
                                              child: const Text(
                                                'Delete For Everyone',
                                              ),
                                              onPressed: () {
                                                for (var element in set) {
                                                  FirebaseFirestore.instance
                                                      .doc(
                                                          "Messages/${widget.data.email}/Messages/${widget.EmailR}/Messages/$element")
                                                      .delete();
                                                  FirebaseFirestore.instance
                                                      .doc(
                                                          "Messages/${widget.EmailR}/Messages/${widget.data.email}/Messages/$element")
                                                      .delete();
                                                }
                                                setState(() {
                                                  set.clear();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          : const SizedBox(),
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          isDelete.value = 0;
                                          setState(() {
                                            set.clear();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          (set.length == 1)
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.copy,
                                      size: 19,
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: copy.value));
                                      isDelete.value = 0;
                                      setState(() {
                                        set.clear();
                                      });
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    ]
                  : [],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  set.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            isDelete.value = 0;
                            setState(() {
                              set.clear();
                            });
                          },
                          icon: const Icon(Icons.arrow_back))
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
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
                        widget.groupName,
                        style:
                            const TextStyle(fontFamily: 'Narrow', fontSize: 23),
                        textAlign: TextAlign.center,
                      ),
                      Text(widget.status,
                          style: TextStyle(
                              fontSize: 15,
                              color: widget.status == "Online"
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: stream,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        controller: scrollController,
                        reverse: isReverse.value,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          QueryDocumentSnapshot x = snapshot.data!.docs[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (set.contains(x.id)) {
                                  if (x['email'] != widget.data.email) {
                                    isDelete.value--;
                                  }
                                  set.remove(x.id);
                                }
                              });
                            },
                            onLongPress: () {
                              copy.value = x['message'];
                              setState(() {
                                if (!set.contains(x.id)) {
                                  if (x['email'] != widget.data.email) {
                                    isDelete.value++;
                                  }
                                  set.add(x.id);
                                } else {
                                  if (x['email'] != widget.data.email) {
                                    isDelete.value--;
                                  }
                                  set.remove(x.id);
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              color: set.contains(x.id)
                                  ? Colors.indigo[100]
                                  : Colors.white,
                              child: Message(
                                text: x['message'],
                                name: x['name'],
                                messageType: x['messageType'],
                                isCurrentUser: x['email'] == widget.data.email,
                                time: DateFormat('hh:mm a')
                                    .format(x['time'].toDate())
                                    .toString(),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
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
                          enableInteractiveSelection: true,
                          controller: MessageScreen.myController,
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
                          if (MessageScreen.myController.text.isNotEmpty) {
                            if (widget.isGroup) {
                              // for group message
                              final firebaseData = {
                                "name": widget.data.name['First'],
                                "time": Timestamp.now(),
                                "email": widget.data.email,
                                "message": MessageScreen.myController.text,
                                "users": [widget.data.email],
                                "messageType": "groupMessage"
                              };

                              // new message to group
                              FirebaseFirestore.instance
                                  .collection(
                                      "GroupMessages/${widget.groupName}/Messages")
                                  .add(firebaseData);

                              // last message user info
                              FirebaseFirestore.instance
                                  .collection("GroupMessages")
                                  .doc(widget.groupName)
                                  .update({
                                "messageText": MessageScreen.myController.text,
                                "time": Timestamp.now(),
                                "latestMessageBy": widget.data.name['First']
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
                              MessageScreen.myController.clear();
                            } else {
                              // for user message
                              final firebaseUserData = {
                                "name": widget.data.name['First'],
                                "time": Timestamp.now(),
                                "email": widget.data.email,
                                "message": MessageScreen.myController.text,
                                "messageType": "userMessage",
                                "users": [widget.data.email],
                              };

                              // sender user
                              FirebaseFirestore.instance
                                  .collection(
                                      "Messages/${widget.data.email}/Messages/${widget.EmailR}/Messages")
                                  .add(firebaseUserData)
                                  .then((value) => {
                                        // receiver user
                                        FirebaseFirestore.instance
                                            .collection(
                                                "Messages/${widget.EmailR}/Messages/${widget.data.email}/Messages")
                                            .doc(value.id)
                                            .set(firebaseUserData)
                                      });

                              // last message info
                              FirebaseFirestore.instance
                                  .collection(
                                      "Messages/${widget.data.email}/Messages")
                                  .doc(widget.EmailR)
                                  .update({
                                "messageText": MessageScreen.myController.text,
                                "time": Timestamp.now(),
                              });

                              // last message info
                              FirebaseFirestore.instance
                                  .collection(
                                      "Messages/${widget.EmailR}/Messages")
                                  .doc(widget.data.email)
                                  .update({
                                "messageText": MessageScreen.myController.text,
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
                          MessageScreen.myController.clear();
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
