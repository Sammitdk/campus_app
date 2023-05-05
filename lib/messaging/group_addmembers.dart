import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_subsystem/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddToGroup extends StatefulWidget {
  const AddToGroup(
      {Key? key,
      required this.data,
      required this.users,
      required this.groupName})
      : super(key: key);
  final dynamic data;
  final List users;
  final String groupName;

  @override
  State<AddToGroup> createState() => _AddToGroupState();
}

class _AddToGroupState extends State<AddToGroup> {
  Future<List> Members() async {
    List<dynamic> list = [];
    QuerySnapshot<Map<String, dynamic>> ans = await FirebaseFirestore.instance
        .collection("Faculty_Detail")
        .where("Email", whereNotIn: widget.users)
        .orderBy("Email")
        .get();

    for (var element in ans.docs) {
      list.add(element.data());
    }

    ans = await FirebaseFirestore.instance
        .collection("Student_Detail")
        .where("Email", whereNotIn: widget.users)
        .orderBy("Email")
        .get();
    for (var element in ans.docs) {
      list.add(element.data());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add"),
        backgroundColor: Colors.indigo[300],
      ),
      body: FutureBuilder(
        future: Members(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  Map<String, dynamic> x = snapshot.data![i];
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: x['imgUrl'],
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            backgroundImage: imageProvider,
                            maxRadius: 30,
                          );
                        },
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profile.gif"),
                          maxRadius: 30,
                        ),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profile.gif"),
                          maxRadius: 30,
                        ),
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${x['Name']['First'].toString().capitalize()} ${x["Name"]['Last'].toString().capitalize()}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${x["Year"] ?? ""} ${x["Branch"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("GroupMessages")
                                .doc(widget.groupName)
                                .update({
                              "users": FieldValue.arrayUnion([x['Email']]),
                            });
                            setState(() {
                              widget.users.add(x['Email']);
                            });
                          },
                          icon: const Icon(Icons.add))
                    ]),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
