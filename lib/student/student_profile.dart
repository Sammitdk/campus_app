// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class StudentProfile extends StatelessWidget {
//   static Map<String,dynamic> info = {};
//   static CollectionReference cr = FirebaseFirestore.instance.collection('Student_Detail');
//   final String prn;
//
//   const StudentProfile({Key? key,required this.prn});
//   static Future<void> getData(String prn) async {
//     DocumentSnapshot qs = await cr.doc(prn).get();
//     info = qs.data() as Map<String,dynamic>;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     getData(prn);
//     print(prn);
//     return Card(
//       color: Colors.green,
//       child: Column(
//         children: [
//           Text(info['Name']['First']),
//           Text(info['Name']['Last']),
//           Text(info['Name']['Middle']),
//           // Text(info['Mobile'][0]),
//
//         ],
//       ),
//     );
//   }
// }
