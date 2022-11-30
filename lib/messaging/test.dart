import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';
import 'Message.dart';

class Test extends HookWidget {
  final bool isShowing;
  const Test({required this.isShowing, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    var isClicked = useState(false);
    var data = StoreProvider.of<AppState>(context).state;

    useEffect(() {});
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white70,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Messages",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      body: Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 0),
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Messages").orderBy('time')
                          .snapshots(),
                      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (ctx, index) {
                                QueryDocumentSnapshot x =
                                    snapshot.data!.docs[index];
                                return Message(
                                  isCurrentUser: x["email"].toString() == data.email,
                                  text: x['message'],
                                  name: x['name'],
                                );
                              });
                        } else {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red));
                        }
                      }),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: isClicked.value
                          ? Colors.transparent
                          : Colors.white70,
                      borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey)
                  ),
                  padding: const EdgeInsets.all(10),
                  // height: 60,
                  // width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     height: 30,
                      //     width: 30,
                      //     decoration: BoxDecoration(
                      //       color: Colors.lightBlue,
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //     child: const Icon(
                      //       Icons.add,
                      //       color: Colors.white,
                      //       size: 20,
                      //     ),
                      //   ),
                      // ),
                      IconButton(onPressed: (){
                        // todo
                        },
                          icon: const Icon(Icons.add,/*color: Colors.white,*/size: 30,)
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
                        onPressed: () {
                          final firebaseData = {
                            "name": data.name['First'],
                            "time": Timestamp.now(),
                            "email" : data.email,
                            "message": myController.text
                          };
                          FirebaseFirestore.instance.collection("Messages").add(firebaseData);
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
              ],
            )),
      ),
    );
  }
}
