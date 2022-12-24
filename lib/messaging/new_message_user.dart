import 'package:campus_subsystem/messaging/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/reducer.dart';

class NewMessage extends HookWidget {
  final dynamic isFaculty;
  const NewMessage({Key? key , required this.isFaculty}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var data = StoreProvider.of<AppState>(context).state;

    dynamic futureDocReference = useState(FirebaseFirestore.instance
        .collection("Student_Detail")
        .orderBy("Name.First")
        .get());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Students",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 60,
              child: FutureBuilder(
                future: futureDocReference.value,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          QueryDocumentSnapshot x = snapshot.data!.docs[i];
                          if(x['Email'] != data.email){
                            return User(
                              imageUrl: x['imgUrl'],
                              name: x['Name'],
                              branch: x['Branch'],
                              year: x['Year'],
                              email: x['Email'],
                              prn: x['PRN'],
                              status: x['status'], isFaculty: isFaculty,
                            );
                          }else{
                            return const SizedBox();
                          }
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                onChanged: (value) {
                  futureDocReference.value = FirebaseFirestore.instance
                      .collection("Student_Detail")
                      .where("Name.First",
                          isGreaterThanOrEqualTo: value.toLowerCase())
                      .where("Name.First",
                          isLessThan: '${value.toLowerCase()}z')
                      .orderBy("Name.First")
                      .get();
                },
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


