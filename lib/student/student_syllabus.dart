import 'package:campus_subsystem/loadpdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';

class StudentSyllabus extends StatelessWidget {
  const StudentSyllabus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var data = StoreProvider.of<AppState>(context).state;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Syllabus",style: TextStyle(fontFamily: 'Narrow', fontSize: 30),textAlign: TextAlign.center,),
        backgroundColor: Colors.indigo[300],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('College/${data.branch}/${data.year}/Syllabus/Subject').snapshots(),
          builder: (context ,AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,i){
                    QueryDocumentSnapshot x = snapshot.data!.docs[i];
                    return InkWell(
                      onTap: ()  {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => LoadPdf( url:x["url"],)));
                      },
                      child: Padding(
                        padding:  const EdgeInsetsDirectional.only(start: 20,end: 20,top: 30),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          color: Colors.white,
                          child: Row(
                            children: [
                              const Expanded(child: Icon(Icons.book_outlined)),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 80,
                                  child: Text(
                                    (x["num"]),textAlign: TextAlign.center,style: const TextStyle(fontSize: 25),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
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



