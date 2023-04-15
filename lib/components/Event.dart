import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../faculty/faculty_event_show.dart';

Widget Event(){
  return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Events").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,i){
                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ShowEvent(x: x,)));
                  },
                  child: Padding(
                    padding:  const EdgeInsetsDirectional.all(18),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      color: Colors.white,
                      child: Row(
                        children: [
                          const Expanded(child: Icon(Icons.event_note_outlined)),
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 80,
                              child: Text((x['Title']),textAlign: TextAlign.center,style: const TextStyle(fontFamily: "Bold",fontSize: 30),),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                              child: Text(x['Date'].toString().substring(0,10) ,
                                style: const TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        return const Center(
          child: CircularProgressIndicator(
          ),
        );
      }
  );
}