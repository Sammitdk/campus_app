import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
        title: const Text(
          "Messages",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            bottom: FocusScope.of(context).hasFocus ? 70 : 50,
            top: 0,
            child: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: CupertinoScrollbar(
                controller: scrollController,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("College/${data.branch}/MessageGroups/$groupName/Messages")
                        .orderBy('time')
                        .snapshots(),
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
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
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
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
                      myController.text.isEmpty
                          ? const SizedBox()
                          : FloatingActionButton(
                              onPressed: () {
                                final firebaseData = {
                                  "name": data.name['First'],
                                  "time": Timestamp.now(),
                                  "email": data.email,
                                  "message": myController.text
                                };
                                FirebaseFirestore.instance
                                    .collection("College/${data.branch}/MessageGroups/$groupName/Messages")
                                    .add(firebaseData);
                                FirebaseFirestore.instance.collection("College/${data.branch}/MessageGroups").doc(groupName).update({
                                  "messageText" : myController.text,
                                  "time" : Timestamp.now()
                                });
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
              )),
        ],
      ),
    );
  }
}
