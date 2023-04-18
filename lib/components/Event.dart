import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../faculty/faculty_event_show.dart';

Widget Event(final isStudent){
  return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Events").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,i){
                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                return Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ShowEvent(x: x,)));
                    },
                    child: !isStudent ? Slidable(
                      key: ValueKey(i),
                      endActionPane: ActionPane(
                        extentRatio: 0.25,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(60),
                            onPressed: (v) async {
                              FirebaseFirestore.instance
                                  .collection("Events")
                                  .where('Title', isEqualTo: x['Title'])
                                  .get()
                                  .then((value) => {
                                FirebaseFirestore.instance
                                    .collection("Events")
                                    .doc(value.docs.first.id)
                                    .delete()
                              });
                            },
                            spacing: 2,
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFFE4A49),
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
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
                    ) : Card(
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
                    )
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