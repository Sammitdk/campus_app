import 'package:campus_subsystem/redux/reducer.dart';
import 'package:campus_subsystem/student/student_sub_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StudentResult extends StatefulWidget {
  const StudentResult({Key? key}) : super(key: key);

  @override
  State<StudentResult> createState() => _StudentResultState();
}

class _StudentResultState extends State<StudentResult> {
  final inst = FirebaseFirestore.instance;
  void launchBrowser() async {
    const url = 'http://14.139.121.222/studentresult/';
    try {
      await launchUrlString(url,
          webViewConfiguration: const WebViewConfiguration(enableJavaScript: true), mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Could not launch $url';
    }
  }

  Stream getResult(user) async* {
    inst.collection("College/$user/Result").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Result",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 1,
        heroTag: "tag",
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo[300],
        onPressed: () => launchBrowser(),
        label: const Text("University Result"),
      ),
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return StreamBuilder(
                stream: inst.collection("Student_Detail/${state.prn}/Result").orderBy('UT.time').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> subjects) {
                  if (subjects.connectionState != ConnectionState.waiting) {
                    if (subjects.hasData && subjects.data!.docs.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: subjects.data?.docs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsetsDirectional.all(10),
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => StudentSubResult(
                                            subject: subjects.data!.docs[index].id,
                                          ))),
                                  child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    elevation: 5,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 80,
                                            child: Text(subjects.data!.docs[index].id,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 20),
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${subjects.data!.docs[index].data().length}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                     
                      return const Center(
                        child: Text(
                          'Records Not Added.',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      );
                    }
                  } else {
                    return Center(child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red));
                  }
                });
          }),
    );
  }
}
