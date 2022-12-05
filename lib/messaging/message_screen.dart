import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';
import 'message.dart';

class MessageScreen extends HookWidget {
  final dynamic groupName;
  final dynamic imageUrl;
  final dynamic isGroup;

  const MessageScreen({
    Key? key,
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

    useEffect(() {
      goDown();
      return null;
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
                      backgroundColor: Colors.indigo[300],
                      title: Text(
                        groupName,
                        style:
                            const TextStyle(fontFamily: 'Narrow', fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
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
              top: 0,
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 60,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: StreamBuilder(
                    stream: isGroup
                        ? FirebaseFirestore.instance
                            .collection("GroupMessages/$groupName/Messages")
                            .orderBy('time')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection(
                                "Student_Detail/${data.prn}/Messages/$groupName/Messages")
                            .orderBy('time')
                            .snapshots(),
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
                        onPressed: () {
                          if (myController.text.isNotEmpty) {
                            final firebaseData = {
                              "name": data.name['First'],
                              "time": Timestamp.now(),
                              "email": data.email,
                              "message": myController.text,
                              "users": [data.email],
                              "messageType": "groupMessage"
                            };
                            final firebaseUserData = {
                              "name": data.name['First'],
                              "time": Timestamp.now(),
                              "email": data.email,
                              "message": myController.text,
                              "messageType": "userMessage",
                              "users": [data.email],
                            };
                            isGroup
                                ? FirebaseFirestore.instance
                                    .collection(
                                        "GroupMessages/$groupName/Messages")
                                    .add(firebaseData)
                                : FirebaseFirestore.instance
                                    .collection(
                                        "Student_Detail/${data.prn}/Messages/$groupName/Messages")
                                    .add(firebaseUserData);
                            isGroup
                                ? FirebaseFirestore.instance
                                    .collection("GroupMessages")
                                    .doc(groupName)
                                    .update({
                                    "messageText": myController.text,
                                    "time": Timestamp.now(),
                                    "latestMessageBy": data.name['First']
                                  })
                                : FirebaseFirestore.instance
                                    .collection(
                                        "Student_Detail/${data.prn}/Messages")
                                    .doc(groupName)
                                    .update({
                                    "messageText": myController.text,
                                    "time": Timestamp.now(),
                                  });
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
