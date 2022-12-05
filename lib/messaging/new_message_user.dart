import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewMessage extends HookWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          return User(
                            imageUrl: x['imgUrl'],
                            name: x['Name'],
                            branch: x['Branch'],
                            year: x['Year'],
                          );
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
                          isGreaterThanOrEqualTo: value.replaceFirst(
                              value[0], value[0].toUpperCase()))
                      .where("Name.First",
                          isLessThan:
                              '${value.replaceFirst(value[0], value[0].toUpperCase())}z')
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

class User extends StatelessWidget {
  final dynamic imageUrl;
  final dynamic name;
  final dynamic branch;
  final dynamic year;
  const User({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.branch,
    required this.year,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(children: <Widget>[
        CircleAvatar(
          backgroundImage: imageUrl != ""
              ? NetworkImage(imageUrl)
              : const AssetImage("assets/images/profile.gif") as ImageProvider,
          maxRadius: 30,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${name['First']} ${name['Last']}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      "$year $branch",
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.messenger_outline_rounded))
      ]),
    );
  }
}
