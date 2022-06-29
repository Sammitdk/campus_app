import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentSyllabus extends StatefulWidget {
  @override
  State<StudentSyllabus> createState() => _StudentSyllabusState();
}

class _StudentSyllabusState extends State<StudentSyllabus> {
  DocumentReference subjects = FirebaseFirestore.instance.doc('/College/CSE/TY/Subjects');
  late  Map<String,dynamic> subject = {};
  @override
  void initState()
  {
    super.initState();
    getSyllabus();
  }
  Future<void> getSyllabus()async {
    DocumentSnapshot syllabusSnapshot = await subjects.get();
    subject = syllabusSnapshot.data() as Map<String,dynamic>;
    print(subject);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
                child: Container(
                  padding: const EdgeInsetsDirectional.only(top: 10),
                    child: const Text("SYLLABUS",style: TextStyle(fontFamily: 'Sticky', fontSize: 50)))),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Expanded(
                    child: Icon(
                        Icons.subject_sharp,
                      size: 40,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 300,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(50),
                              topEnd: Radius.circular(50),
                              bottomEnd: Radius.circular(50),
                              bottomStart: Radius.circular(50)),
                          color: Colors.limeAccent
                      ),
                      child: Text("${subject["6"]["ML"]}",style: const TextStyle(fontFamily: 'Bold', fontSize: 30),),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Expanded(
                    child: Icon(
                      Icons.subject_sharp,
                      size: 40,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 300,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(50),
                              topEnd: Radius.circular(50),
                              bottomEnd: Radius.circular(50),
                              bottomStart: Radius.circular(50)),
                          color: Colors.limeAccent
                      ),
                      child: const Text("Machine Learning ",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Expanded(
                    child: Icon(
                      Icons.subject_sharp,
                      size: 40,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 300,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(50),
                              topEnd: Radius.circular(50),
                              bottomEnd: Radius.circular(50),
                              bottomStart: Radius.circular(50)),
                          color: Colors.limeAccent
                      ),
                      child: const Text("Operating System 2 ",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Expanded(
                    child: Icon(
                      Icons.subject_sharp,
                      size: 40,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 300,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(50),
                              topEnd: Radius.circular(50),
                              bottomEnd: Radius.circular(50),
                              bottomStart: Radius.circular(50)),
                          color: Colors.limeAccent
                      ),
                      child: const Text("Compile Construction ",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Expanded(
                    child: Icon(
                      Icons.subject_sharp,
                      size: 40,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 300,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(50),
                              topEnd: Radius.circular(50),
                              bottomEnd: Radius.circular(50),
                              bottomStart: Radius.circular(50)),
                          color: Colors.limeAccent
                      ),
                      child: const Text("Cyber Security ",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
