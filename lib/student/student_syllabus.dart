
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentSyllabus extends StatefulWidget {
  Map<String,dynamic> info;
  StudentSyllabus({Key? key,required this.info}) : super(key: key);
  @override
  State<StudentSyllabus> createState() => _StudentSyllabusState();
}

class _StudentSyllabusState extends State<StudentSyllabus> {
  Map<String,dynamic> subject = {};
  Future<Map<String,dynamic>> getSyllabus()async {
    DocumentReference subjects = FirebaseFirestore.instance.doc('/College/${widget.info['Branch']}/${widget.info['Year']}/Subjects');
    DocumentSnapshot syllabusSnapshot = await subjects.get();
    return syllabusSnapshot.data() as Map<String, dynamic>;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,dynamic>>(
      future: getSyllabus(),
      builder: (context,AsyncSnapshot subject) {
        if(subject.connectionState == ConnectionState.waiting){
          return const Scaffold(
            backgroundColor: Colors.transparent,
              body: Center(child: CircularProgressIndicator(value: 1,backgroundColor: Colors.transparent,)));
        }else{
          if(subject.hasError){return Text(subject.error.toString());}
          else{
            // return Text(subject.data.toString());
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.indigo[300],
                  centerTitle: true,
                  title: const Text("SYLLABUS",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
                ),
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsetsDirectional.all(20),
                  child: Column(
                    children: [
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
                                decoration:  BoxDecoration(
                                    borderRadius: const BorderRadiusDirectional.only(
                                        topStart: Radius.circular(50),
                                        topEnd: Radius.circular(50),
                                        bottomEnd: Radius.circular(50),
                                        bottomStart: Radius.circular(50)),
                                  color: Colors.blue[100],
                                ),
                                child: Text("${subject.data["6"]["ML"]}",style: const TextStyle(fontFamily: 'Bold', fontSize: 30),),
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
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadiusDirectional.only(
                                        topStart: Radius.circular(50),
                                        topEnd: Radius.circular(50),
                                        bottomEnd: Radius.circular(50),
                                        bottomStart: Radius.circular(50)),
                                  color: Colors.blue[100],
                                ),
                                child: Text("${subject.data["6"]["CC"]}",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
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
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadiusDirectional.only(
                                        topStart: Radius.circular(50),
                                        topEnd: Radius.circular(50),
                                        bottomEnd: Radius.circular(50),
                                        bottomStart: Radius.circular(50)),
                                  color: Colors.blue[100],
                                ),
                                child: Text("${subject.data["6"]["OS2"]}",style: const TextStyle(fontFamily: 'Bold', fontSize: 30),),
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
                                decoration:  BoxDecoration(
                                    borderRadius: const BorderRadiusDirectional.only(
                                        topStart: Radius.circular(50),
                                        topEnd: Radius.circular(50),
                                        bottomEnd: Radius.circular(50),
                                        bottomStart: Radius.circular(50)),
                                    color: Colors.blue[100],
                                ),
                                child: Text("${subject.data["6"]["DBMS"]}",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
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
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadiusDirectional.only(
                                        topStart: Radius.circular(50),
                                        topEnd: Radius.circular(50),
                                        bottomEnd: Radius.circular(50),
                                        bottomStart: Radius.circular(50)),
                                  color: Colors.blue[100],
                                ),
                                child: Text("${subject.data["6"]["CS"]}",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            );
          }
        }
      }
    );
  }
}
