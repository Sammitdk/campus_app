import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowEvent extends StatelessWidget {
  ShowEvent({Key? key,required this.x}) : super(key: key);
  QueryDocumentSnapshot x;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(x['Title'],style: const TextStyle(fontSize: 30,fontFamily: 'Narrow'),),
        backgroundColor: Colors.indigo[300],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(x['Description'],style: const TextStyle(fontFamily: 'Muli',fontSize: 20,),),
              )
          ),
          Expanded(
              flex: 2,
              child: x['urlEvent']!= null ? Image.network(x['urlEvent']): Image.asset(
                "assets/images/events.gif",
              )
          )
        ],
      ),
    );
  }
}
