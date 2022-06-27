
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentProfile extends StatelessWidget
{
  final Map<String,dynamic> info ;
  const StudentProfile({Key? key,required this.info}) : super(key: key);


  // Map<String,dynamic> info = {};
  // final CollectionReference cr = FirebaseFirestore.instance.collection('Student_Detail');
  // final String prn;
  // //
  // //
  // //
  // StudentProfile({required this.prn}){
  //   getData(prn);
  // }
  // Future<void> getData(String prn) async
  // {
  //   DocumentSnapshot qs = await cr.doc(prn).get();
  //   info = qs.data() as Map<String,dynamic>;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(info['Name']['First']),
        Text(info['Name']['Last']),
        Text(info['Name']['Middle']),
        // Text(info['Mobile'][0]),
      ],
    );
  }

}



