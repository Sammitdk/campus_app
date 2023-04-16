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
  final dynamic email;
  final dynamic prn;
  final dynamic status;
  final dynamic storeData;

  const User({
    Key? key,
    required this.storeData,
    required this.imageUrl,
    required this.name,
    required this.branch,
    required this.year,
    this.email,
    this.prn,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(children: <Widget>[
        CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              backgroundImage: imageProvider,
              maxRadius: 30,
            );
          },
          placeholder: (context, url) =>
          const CircleAvatar(
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
                Text(
                  "${name['First'].toString().capitalize()} ${name['Last'].toString().capitalize()}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      "$year $branch",
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              final data = {
                'groupName': name['First'],
                'imgUrl': imageUrl,
                'isGroup': false,
                'isMessageRead': false,
                'messageText': "",
                'messageType': 'userMessage',
                'time': Timestamp.now(),
                'prn': prn
              };
              final myData = {
                'groupName': storeData.name['First'],
                'imgUrl': storeData.imgUrl,
                'isGroup': false,
                'isMessageRead': false,
                'messageText': "",
                'messageType': 'userMessage',
                'time': Timestamp.now(),
                'prn': storeData.prn
              };

              FirebaseFirestore.instance
                  .collection("Student_Detail/${storeData.prn}/Messages")
                  .doc(prn)
                  .get()
                  .then((value) => {
                        if (value.exists)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MessageScreen(
                                          status: status,
                                          groupName: name['First'],
                                          imageUrl: imageUrl,
                                          isGroup: false,
                                          prn: prn,
                                          data: storeData,
                                        )))
                          }
                        else
                          {
                            FirebaseFirestore.instance
                                .collection(
                                    "Student_Detail/${storeData.prn}/Messages")
                                .doc(prn)
                                .set(data, SetOptions(merge: true)),
                            FirebaseFirestore.instance
                                .collection("Student_Detail/$prn/Messages")
                                .doc(storeData.prn)
                                .set(myData, SetOptions(merge: true)),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MessageScreen(
                                          status: status,
                                          groupName: name['First'],
                                          imageUrl: imageUrl,
                                          isGroup: false,
                                          prn: prn,
                                          data: storeData,
                                        )))
                          }
                      });
            },
            icon: const Icon(Icons.messenger_outline_rounded))
      ]),
    );
  }
}
