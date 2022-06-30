
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentSyllabus extends StatefulWidget {
  Map<String,dynamic> subject;
  StudentSyllabus({Key? key,required this.subject}) : super(key: key);
  @override
  State<StudentSyllabus> createState() => _StudentSyllabusState();
}

class _StudentSyllabusState extends State<StudentSyllabus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text("SYLLABUS",style: TextStyle(fontFamily: 'Sticky', fontSize: 40),textAlign: TextAlign.center,),
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
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(50),
                              topEnd: Radius.circular(50),
                              bottomEnd: Radius.circular(50),
                              bottomStart: Radius.circular(50)),
                          color: Colors.limeAccent
                      ),
                      child: Text("${widget.subject["6"]["ML"]}",style: const TextStyle(fontFamily: 'Bold', fontSize: 30),),
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
                      child: Text("${widget.subject["6"]["CC"]}",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
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
                      child: Text("${widget.subject["6"]["OS2"]}",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
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
                      child: Text("${widget.subject["6"]["DBMS"]}",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
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
                      child: Text("${widget.subject["6"]["CS"]}",style: TextStyle(fontFamily: 'Bold', fontSize: 30),),
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
