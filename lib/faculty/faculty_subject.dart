import 'package:campus_subsystem/loadpdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';

class FacultySubject extends StatefulWidget {
  const FacultySubject({Key? key}) : super(key: key);

  @override
  State<FacultySubject> createState() => _FacultySubjectState();
}

class _FacultySubjectState extends State<FacultySubject> {
  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<AppState>(context).state;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Subjects",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('/Faculty_Detail/${state.email}/Subjects')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    QueryDocumentSnapshot x = snapshot.data!.docs[i];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => LoadPdf(url: x["url"])));
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 20, end: 20, top: 40),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          color: Colors.blue[100],
                          child: Container(
                            alignment: Alignment.center,
                            height: 80,
                            child: Text(
                              (x["num"]),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
            return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    size: 50, color: Colors.red));
          }),
    );
  }
}
