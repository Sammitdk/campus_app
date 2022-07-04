
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class StudentSyllabus extends StatefulWidget {
  StudentSyllabus({Key? key,required this.info}) : super(key: key);
  Map<String,dynamic> info ;


  @override
  State<StudentSyllabus> createState() => _StudentSyllabusState();
}

class _StudentSyllabusState extends State<StudentSyllabus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Syllabus",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
        backgroundColor: Colors.indigo[300],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('/College/${widget.info['Branch']}/${widget.info['Year']}/Syllabus/Subject').snapshots(),
          builder: (context ,AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,i){

                    QueryDocumentSnapshot x = snapshot.data!.docs[i];
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => LoadFirebasePdf(url: x["url"],)));
                      },
                      child: Expanded(
                        child: Padding(
                          padding:  const EdgeInsetsDirectional.all(10),
                          child: Container(
                            alignment: Alignment.center,
                            height: 80,
                            // width: 300,
                            decoration:  BoxDecoration(
                                borderRadius:
                                const BorderRadiusDirectional.only(
                                    topStart: Radius.circular(50),
                                    topEnd: Radius.circular(50),
                                    bottomEnd: Radius.circular(50),
                                    bottomStart:
                                    Radius.circular(50)),
                                color: Colors.blue[100]),
                            child: Text((x["num"]),textAlign: TextAlign.center,style: const TextStyle(fontFamily: "Bold",fontSize: 30),),
                          ),
                        ),
                      ),
                    );
                  });
            }
               QueryDocumentSnapshot x = snapshot.data!.docs[i];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LoadFirebasePdf(url: x["url"],)));
                  },
                  child: Expanded(
                    child: Padding(
                      padding:  const EdgeInsetsDirectional.all(20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 80,
                        // width: 300,
                        decoration:  BoxDecoration(
                            borderRadius:
                            const BorderRadiusDirectional.only(
                                topStart: Radius.circular(50),
                                topEnd: Radius.circular(50),
                                bottomEnd: Radius.circular(50),
                                bottomStart:
                                Radius.circular(50)),
                            color: Colors.blue[100]),
                        child: Text((x["num"]),textAlign: TextAlign.center,style: const TextStyle(fontSize: 25),),
                    ),
                  ),
                  ),
                );
            });
          }
            return const Center(
                child: CircularProgressIndicator());
          }
      ),
    );
  }
}

class LoadFirebasePdf extends StatelessWidget {
  PdfViewerController? _pdfViewerController;
  final url;
  LoadFirebasePdf({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.network(
        url,
        controller: _pdfViewerController,
      ),
    );
  }
}