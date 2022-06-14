import 'package:campus_subsystem/faculty/recievemessege.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  static final formkey = GlobalKey<FormState>();
  static Widget sendField() => Form(
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
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: sendField(),
    );
  }
}