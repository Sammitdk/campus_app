import 'package:campus_subsystem/messaging/read_message-fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/reducer.dart';
import '../redux/store.dart';
import 'message_screen.dart';

class ConversationList extends HookWidget {
  final String name;
  final String messageText;
  final String imageUrl;
  final String time;
  final bool isMessageRead;
  final String latestMessageBy;
  final int count;
  final dynamic isGroup;
  const ConversationList(
      {Key? key,
      required this.name,
      required this.isGroup,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      required this.latestMessageBy,
      required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = StoreProvider.of<AppState>(context).state;
    var countState = useState(count);
    getMessageReads(store.state, name, isGroup)
        .then((value) => {countState.value = value});

    return InkWell(
      onTap: () {
        countState.value = 0;
        isGroup
            ? FirebaseFirestore.instance
                .collection("GroupMessages")
                .doc(name)
                .update({"isMessageRead": true})
            : FirebaseFirestore.instance
                .collection("Student_Detail/${data.prn}/Messages")
                .doc(name)
                .update({"isMessageRead": true});
        readAll(store.state, name, isGroup);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MessageScreen(
                    groupName: name, imageUrl: imageUrl, isGroup: isGroup)));
      },
      child: IgnorePointer(
        child: Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      maxRadius: 30,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                isGroup
                                    ? Text(
                                        "$latestMessageBy : ",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                            fontWeight: isMessageRead
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      )
                                    : const SizedBox(),
                                messageText.length >= 10
                                    ? Text(
                                        "${messageText.substring(0, 10)}...",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade600,
                                            fontWeight: !isMessageRead
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      )
                                    : Text(
                                        messageText,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade600,
                                            fontWeight: !isMessageRead
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 10),
                    child: Text(
                      time,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: !isMessageRead
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                  countState.value == 0
                      ? const SizedBox()
                      : Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: Colors.green[400], shape: BoxShape.circle),
                          child: Text(countState.value.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white)),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
