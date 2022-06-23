import 'package:flutter/material.dart';


class Test extends StatefulWidget {

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  // static List cate = [];

  @override
  Widget build(BuildContext context){
    // dynamic m =  getData('25');
    // print(m);

    return Text("Hi there");
    // return Scaffold(
    //     body: StreamBuilder(
    //       stream: student.snapshots(),
    //       builder: (context,AsyncSnapshot<dynamic> snapshot){
    //         if(snapshot.hasData){
    //           // Map<String,dynamic> data = snapshot.data.data;
    //           // print(data);
    //           return ListView.builder(
    //             itemCount: snapshot.data!.docs.length,
    //             itemBuilder: (context,index){
    //               final DocumentSnapshot documentsnapshot = snapshot.data!.docs[index];
    //               print(documentsnapshot.data());
    //               return Card(
    //                 child: ListTile(title: Text(documentsnapshot['name'])),
    //               );
    //             },
    //           );
    //         }
    //         return Text("data not found");
    //       },
    //     )
    // );
  }
}
