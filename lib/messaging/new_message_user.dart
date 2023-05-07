import 'package:campus_subsystem/messaging/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewMessage extends HookWidget {
  final dynamic data;
  final List<dynamic> facultyList;

  const NewMessage({Key? key, required this.data, required this.facultyList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic futureDocReferenceStudent = useState(FirebaseFirestore.instance
        .collection("Student_Detail")
        .orderBy("Name.First")
        .get());
    dynamic futureDocReferenceFaculty = useState(FirebaseFirestore.instance
        .collection("Faculty_Detail")
        .orderBy("Name.First")
        .get());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[300],
          foregroundColor: Colors.white,
          title: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.green,
            tabs: [
              Text(
                "Students",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "Faculty",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 60,
                    child: FutureBuilder(
                      future: futureDocReferenceStudent.value,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                QueryDocumentSnapshot x =
                                    snapshot.data!.docs[i];
                                if (x['Email'] != data.email) {
                                  return User(
                                    imageUrl: x['imgUrl'],
                                    name: x['Name'],
                                    branch: x['Branch'],
                                    year: x['Year'],
                                    EmailR: x['Email'],
                                    storeData: data,
                                    facultyList: facultyList,
                                    admins: const [],
                                  );
                                } else {
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
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: TextField(
                      onChanged: (value) {
                        futureDocReferenceStudent.value = FirebaseFirestore
                            .instance
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
                            borderSide:
                                BorderSide(color: Colors.grey.shade100)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 60,
                    child: FutureBuilder(
                      future: futureDocReferenceFaculty.value,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                QueryDocumentSnapshot x =
                                    snapshot.data!.docs[i];
                                if (x['Email'] != data.email) {
                                  return User(
                                    imageUrl: x['imgUrl'],
                                    name: x['Name'],
                                    branch: x['Branch'],
                                    EmailR: x['Email'],
                                    storeData: data,
                                    facultyList: facultyList,
                                    admins: const [],
                                  );
                                } else {
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
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: TextField(
                      onChanged: (value) {
                        futureDocReferenceFaculty.value = FirebaseFirestore
                            .instance
                            .collection("Faculty_Detail")
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
                            borderSide:
                                BorderSide(color: Colors.grey.shade100)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
