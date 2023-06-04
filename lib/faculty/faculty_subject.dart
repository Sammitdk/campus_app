import 'package:campus_subsystem/loadpdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';

class FacultySubject extends StatefulWidget {
  final String email;
  final String branch;

  const FacultySubject({Key? key, required this.email, required this.branch})
      : super(key: key);

  @override
  State<FacultySubject> createState() => _FacultySubjectState();
}

class _FacultySubjectState extends State<FacultySubject> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<List> fetchData() async {
    List ans = [];
    DocumentSnapshot value = await FirebaseFirestore.instance
        .doc('Faculty_Detail/${widget.email}')
        .get();

    Map<String, dynamic> map = value.data() as Map<String, dynamic>;
    List<String> subjects = map['Subjects'].keys.toList();

    await FirebaseFirestore.instance
        .collection('College/${widget.branch}/FY/Syllabus/Subject')
        .get()
        .then((value) {
      for (var element in value.docs) {
        var data = element.data();
        if (subjects.contains(data['num'])) {
          ans.add(data);
        }
      }
    });
    await FirebaseFirestore.instance
        .collection('College/${widget.branch}/SY/Syllabus/Subject')
        .get()
        .then((value) {
      for (var element in value.docs) {
        var data = element.data();
        if (subjects.contains(data['num'])) {
          ans.add(data);
        }
      }
    });

    await FirebaseFirestore.instance
        .collection('College/${widget.branch}/TY/Syllabus/Subject')
        .get()
        .then((value) {
      for (var element in value.docs) {
        var data = element.data();
        if (subjects.contains(data['num'])) {
          ans.add(data);
        }
      }
    });
    await FirebaseFirestore.instance
        .collection('College/${widget.branch}/BE/Syllabus/Subject')
        .get()
        .then((value) {
      for (var element in value.docs) {
        var data = element.data();
        if (subjects.contains(data['num'])) {
          ans.add(data);
        }
      }
    });
    return ans;
  }

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
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    Map<String, dynamic> x = snapshot.data![i];
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
                          color: Colors.white,
                          child: Container(
                            alignment: Alignment.center,
                            height: 80,
                            child: Text(
                              (x["num"]),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.black),
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
