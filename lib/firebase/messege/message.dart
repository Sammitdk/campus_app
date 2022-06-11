import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Form(
        key: formkey,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(padding: EdgeInsets.only(left: 10,bottom: 10),
                child: TextFormField(
                  validator: (text){
                    if(text == null || text.isEmpty){
                      return 'Messege is Empty.';
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(padding: EdgeInsets.all(15),
                child: FloatingActionButton(
                  child: Icon(Icons.send),
                  onPressed: (){
                    if(formkey.currentState!.validate()){
                      print("Ok");
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
