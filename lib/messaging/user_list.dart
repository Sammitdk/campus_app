import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'message_screen.dart';
import "package:campus_subsystem/main.dart";

class User extends StatelessWidget {
  final dynamic imageUrl;
  final dynamic name;
  final dynamic branch;
  final dynamic year;
  final dynamic EmailR;
  final dynamic storeData;
  final dynamic facultyList;
  final List admins;

  const User({
    Key? key,
    required this.storeData,
    required this.imageUrl,
    required this.name,
    required this.branch,
    required this.admins,
    this.year,
    this.facultyList,
    required this.EmailR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(children: <Widget>[
        CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              backgroundImage: imageProvider,
              maxRadius: 30,
            );
          },
          placeholder: (context, url) => const CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile.gif"),
            maxRadius: 30,
          ),
          errorWidget: (context, url, error) => const CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile.gif"),
            maxRadius: 30,
          ),
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                admins.contains(EmailR)
                    ? const Text(
                        "Group Admin",
                        style: TextStyle(fontSize: 12, color: Colors.green),
                        textAlign: TextAlign.end,
                      )
                    : const SizedBox(),
                Text(
                  "${name['First'].toString().capitalize()} ${name['Last'].toString().capitalize()}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    facultyList.isNotEmpty && facultyList.contains(EmailR)
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 7,
                            child: Image.network(
                                "https://firebasestorage.googleapis.com/v0/b/campus-76c01.appspot.com/o/icons%2Fpinpng.com-instagram-png-logo-577224.png?alt=media&token=a0bf0fc5-18ab-4ac3-8fc9-7f24580ae332"),
                          )
                        : const SizedBox(),
                    Text(
                      "${year ?? ""} $branch",
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        storeData.email != EmailR
            ? IconButton(
                onPressed: () {
                  try {
                    // todo
                  } catch (e) {}
                  final data = {
                    'groupName': name['First'],
                    'imgUrl': imageUrl,
                    'isGroup': false,
                    'isMessageRead': false,
                    'messageText': "",
                    'messageType': 'userMessage',
                    'time': Timestamp.now(),
                    'email': EmailR,
                  };
                  final myData = {
                    'groupName': storeData.name['First'],
                    'imgUrl': storeData.imgUrl,
                    'isGroup': false,
                    'isMessageRead': false,
                    'messageText': "",
                    'messageType': 'userMessage',
                    'time': Timestamp.now(),
                    'email': storeData.email,
                  };

                  FirebaseFirestore.instance.collection("Messages/${storeData.email}/Messages").doc(EmailR).get().then((value) => {
                        if (value.exists)
                          {
                            print(imageUrl),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MessageScreen(
                                          //TODO staus fetch
                                          status: "Offline",
                                          groupName: name['First'],
                                          imageUrl: imageUrl,
                                          isGroup: false,
                                          EmailR: EmailR,
                                          data: storeData,
                                        )))
                          }
                        else
                          {
                            FirebaseFirestore.instance
                                .collection("Messages/${storeData.email}/Messages")
                                .doc(EmailR)
                                .set(data, SetOptions(merge: true)),
                            FirebaseFirestore.instance
                                .collection("Messages")
                                .doc(EmailR)
                                .set({'status': "Offline"}, SetOptions(merge: true)),
                            FirebaseFirestore.instance
                                .collection("Messages/$EmailR/Messages")
                                .doc(storeData.email)
                                .set(myData, SetOptions(merge: true)),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MessageScreen(
                                          status: "Offline",
                                          groupName: name['First'],
                                          imageUrl: imageUrl,
                                          isGroup: false,
                                          EmailR: EmailR,
                                          data: storeData,
                                        )))
                          }
                      });
                },
                icon: const Icon(Icons.messenger_outline_rounded))
            : const SizedBox()
      ]),
    );
  }
}
