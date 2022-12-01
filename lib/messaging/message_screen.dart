import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';
import 'message.dart';

class MessageScreen extends HookWidget {
  final dynamic groupName;
  const MessageScreen({Key? key, required this.groupName}) : super(key: key);

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

    useEffect(() {
      goDown();
      return null;
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          groupName,
          style: const TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: InkWell(
              focusColor: Colors.white,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(
                          "College/${data.branch}/MessageGroups/$groupName/Messages")
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
                              isCurrentUser:
                                  x["email"].toString() == data.email,
                              text: x['message'],
                              name: x['name'],
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
                            "users" : [data.email]
                          };
                          FirebaseFirestore.instance
                              .collection(
                                  "College/${data.branch}/MessageGroups/$groupName/Messages")
                              .add(firebaseData);
                          FirebaseFirestore.instance
                              .collection(
                                  "College/${data.branch}/MessageGroups")
                              .doc(groupName)
                              .update({
                            "messageText": myController.text,
                            "time": Timestamp.now(),
                            "latestMessageBy" : data.name['First']
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
    );
  }
}
