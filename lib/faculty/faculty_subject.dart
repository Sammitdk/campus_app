
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class FacultySubject extends StatefulWidget {
  FacultySubject({Key? key,required this.info}) : super(key: key);
  Map<String,dynamic> info ;

  @override
  State<FacultySubject> createState() => _FacultySubjectState();
}

class _FacultySubjectState extends State<FacultySubject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Subjects",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
        backgroundColor: Colors.indigo[300],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('/Faculty_Detail/${widget.info['Email']}/Subjects').snapshots(),
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
                      child: Padding(
                        padding:  const EdgeInsetsDirectional.only(start: 20,end: 20,top: 50),
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
                    );
                  });
            }
            return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red));
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
