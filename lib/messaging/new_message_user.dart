import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../redux/reducer.dart';

class NewMessage extends StatelessWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = StoreProvider.of<AppState>(context).state;
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Student_Detail/${data.prn}")
            .get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                return InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => ShowEvent(x: x,)));
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(18),
                    child: Container(
                      alignment: Alignment.center,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadiusDirectional.only(
                              topStart: Radius.circular(50),
                              topEnd: Radius.circular(50),
                              bottomEnd: Radius.circular(50),
                              bottomStart: Radius.circular(50)),
                          color: Colors.blue[100]),
                      child: Text(
                        (x['Name']['First']),
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontFamily: "Bold", fontSize: 30),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
