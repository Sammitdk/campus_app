import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {
  final Map<String, dynamic> info;
  final FirebaseAuth auth = FirebaseAuth.instance;
  StudentProfile({Key? key, required this.info}) : super(key: key);


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
    return Padding(
      padding: const EdgeInsetsDirectional.all(30),
      child: Column(
            children: [
              Expanded(
                flex: 3,
                  child: Image.asset("assets/images/profile.gif")),
              Expanded(
                flex: 1,
                child: Column(
                  children: const [
                    Text("My Profile",style: TextStyle(fontSize: 40,fontFamily: 'Bold',),),
                ]
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children:  [
                          Text("${info['Name']['First']} ${info['Name']['Middle']} ${info['Name']['Middle']}", style: const TextStyle(fontSize: 30,fontFamily:'Narrow',),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(info['Branch'],style: const TextStyle(fontSize: 30,fontFamily:'Narrow',),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(info['DOB'],style: const TextStyle(fontSize: 30,fontFamily:'Narrow',),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(info['Mobile'][0],style: const TextStyle(fontSize: 30,fontFamily:'Narrow',),),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              onPressed: () async {
                                await auth.signOut();
                              },
                              child:
                              const Icon(Icons.logout,size: 30,color: Colors.black,),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                              padding: const EdgeInsetsDirectional.only(top: 10),
                              child: const Text("Log Out",style: TextStyle(fontSize: 30,fontFamily:'Bold',))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
//
// Column(
// children: [
// Text(info['Name']['First']),
// Text(info['Name']['Last']),
// Text(info['Name']['Middle']),
// // Text(info['Mobile'][0]),
// ],
// ),
