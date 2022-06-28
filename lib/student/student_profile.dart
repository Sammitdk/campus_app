import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {
  final Map<String, dynamic> info;
  final FirebaseAuth auth = FirebaseAuth.instance;
  StudentProfile({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: const EdgeInsetsDirectional.all(30),
    //   child: Column(
    //         children: [
    //           Expanded(
    //             flex: 3,
    //               child: Image.asset("assets/images/profile.gif")),
    //           Expanded(
    //             flex: 1,
    //             child: Column(
    //               children: const [
    //                 Text("My Profile",style: TextStyle(fontSize: 40,fontFamily: 'Bold',),),
    //             ]
    //             ),
    //           ),
    //           Expanded(
    //             flex: 4,
    //             child: Column(
    //               children: [
    //                 Expanded(
    //                   child: Row(
    //                     children:  [
    //                       Text("${info['Name']['First']} ${info['Name']['Middle']} ${info['Name']['Middle']}", style: const TextStyle(fontSize: 30,fontFamily:'Narrow',),),
    //                     ],
    //                   ),
    //                 ),
    //                 Expanded(
    //                   child: Row(
    //                     children: [
    //                       Text(info['Branch'],style: const TextStyle(fontSize: 30,fontFamily:'Narrow',),),
    //                     ],
    //                   ),
    //                 ),
    //                 Expanded(
    //                   child: Row(
    //                     children: [
    //                       Text(info['DOB'],style: const TextStyle(fontSize: 30,fontFamily:'Narrow',),),
    //                     ],
    //                   ),
    //                 ),
    //                 Expanded(
    //                   child: Row(
    //                     children: [
    //                       Text(info['Mobile'][0],style: const TextStyle(fontSize: 30,fontFamily:'Narrow',),),
    //                     ],
    //                   ),
    //                 ),
    //                 Expanded(
    //                   flex: 2,
    //                   child: Column(
    //                     children: [
    //                       Container(
    //                         alignment: Alignment.bottomRight,
    //                         child: FloatingActionButton(
    //                           backgroundColor: Colors.white,
    //                           onPressed: () async {
    //                             await auth.signOut();
    //                           },
    //                           child:
    //                           const Icon(Icons.logout,size: 30,color: Colors.black,),
    //                         ),
    //                       ),
    //                       Container(
    //                         alignment: Alignment.bottomRight,
    //                           padding: const EdgeInsetsDirectional.only(top: 10),
    //                           child: const Text("Log Out",style: TextStyle(fontSize: 30,fontFamily:'Bold',))),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    // );
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Image.asset("assets/images/profile.gif")
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.amber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Icon(Icons.person),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${info['Name']['First']}", style: const TextStyle(fontSize: 30,fontFamily:'Narrow',),),
                            Text("${info['Name']['First']} ${info['Name']['Middle']} ${info['Name']['Last']}", style: const TextStyle(fontSize: 15,fontFamily:'Narrow',),),
                            // Text("${info['Email']}",style: const TextStyle(fontSize: 15,fontFamily:'Narrow',)),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${Icons.mail} : ${info['Email']}",style: const TextStyle(fontSize: 20,fontFamily:'Narrow',)),
                        Text("${Icons.cake} : ${info['DOB']}",style: const TextStyle(fontSize: 20,fontFamily:'Narrow',)),
                        Text("${Icons.call} : ${info['Mobile'][0]}",style: const TextStyle(fontSize: 20,fontFamily:'Narrow',)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () async => await auth.signOut(), label: const Text('LogOut'),icon: const Icon(Icons.logout),backgroundColor: Colors.white,foregroundColor: Colors.black,),
    );
  }
}