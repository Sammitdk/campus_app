import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'Message.dart';

class Test extends HookWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isClicked = useState(false);
    return Scaffold(
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(flex: 8, child: ListView(
                  children: const [
                    Message(
                      text: 'Hey',
                      isCurrentUser: true,
                    ),
                    Message(
                      text:
                          'Hey iam fine what about you dkjabhdjkkkkkkdkahduhaiiiiiiiiiiiudkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkka ? ',
                      isCurrentUser: false,
                    ),
                    Message(
                      text:
                          'GoodhkAjdhkajhdkajhdiu haiuhduiah iudhauihda uhiuhd aiuhduaihdad',
                      isCurrentUser: true,
                    ),
                    Message(
                      text:
                      'GoodhkAjdhkajhdkajhdiu haiuhduiah iudhauihda uhiuhd aiuhduaihdad',
                      isCurrentUser: true,
                    ),Message(
                      text:
                      'GoodhkAjdhkajhdkajhdiu haiuhduiah iudhauihda uhiuhd aiuhduaihdad',
                      isCurrentUser: true,
                    ),Message(
                      text:
                      'GoodhkAjdhkajhdkajhdiu haiuhduiah iudhauihda uhiuhd aiuhduaihdad',
                      isCurrentUser: true,
                    ),
                  ],
                )),
                Expanded(
                  flex: isClicked.value ? 2 : 1,
                  child: Align(
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: isClicked.value ? Colors.transparent : Colors.white,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
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
                            child: GestureDetector(
                              onTap: () {
                                isClicked.value = true;
                              },
                              child: const TextField(
                                decoration: InputDecoration(
                                    hintText: "Write message...",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            onPressed: () {},
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
            )),
      ),
    );
  }
}
