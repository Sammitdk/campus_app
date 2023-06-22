import 'package:campus_subsystem/loadpdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/actions/fetchUserData.dart';
import '../redux/reducer.dart';

class FacultySubject extends StatefulWidget {
  final String email;
  final String branch;

  const FacultySubject({Key? key, required this.email, required this.branch}) : super(key: key);

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
    DocumentSnapshot value = await FirebaseFirestore.instance.doc('Faculty_Detail/${widget.email}').get();

    Map<String, dynamic> map = value.data() as Map<String, dynamic>;
    List<String> subjects = map['Subjects'].keys.toList();

    await FirebaseFirestore.instance.collection('College/${widget.branch}/FY/Syllabus/Subject').get().then((value) {
      for (var element in value.docs) {
        var data = element.data();
        if (subjects.contains(data['num'])) {
          ans.add(data);
        }
      }
    });
    await FirebaseFirestore.instance.collection('College/${widget.branch}/SY/Syllabus/Subject').get().then((value) {
      for (var element in value.docs) {
        var data = element.data();
        if (subjects.contains(data['num'])) {
          ans.add(data);
        }
      }
    });

    await FirebaseFirestore.instance.collection('College/${widget.branch}/TY/Syllabus/Subject').get().then((value) {
      for (var element in value.docs) {
        var data = element.data();
        if (subjects.contains(data['num'])) {
          ans.add(data);
        }
      }
    });
    await FirebaseFirestore.instance.collection('College/${widget.branch}/BE/Syllabus/Subject').get().then((value) {
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
                        Navigator.push(context, MaterialPageRoute(builder: (_) => LoadPdf(url: x["url"])));
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 40),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          color: Colors.white,
                          child: Container(
                            alignment: Alignment.center,
                            height: 80,
                            child: Text(
                              (x["num"]),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 25, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
            return Center(child: LoadingAnimationWidget.staggeredDotsWave(size: 50, color: Colors.red));
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialogAddNewSubject(state.email, state.branch);
          },
          label: const Text("Add subject")),
    );
  }

  Future<bool> showDialogAddNewSubject(String name, String branch) async {
    TextEditingController subjectNamecontroller = TextEditingController();
    Map<String, dynamic> records = {};

    Map<String, List<String>> years = {
      'FY': ['1', '2'],
      'SY': ['3', '4'],
      'TY': ['5', '6'],
      'BE': ['7', '8'],
    };

    String selectedyear = years.keys.elementAt(0);
    String selectedsem = years[selectedyear]![0];

    final rec = GlobalKey<FormState>();
    return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.indigo[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                alignment: Alignment.center,
                title: const Text(
                  "Add Subject",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: rec,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: subjectNamecontroller,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(color: Colors.white),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Subject',
                              ),
                              validator: (key) {
                                if (key == null || key.isEmpty) {
                                  return "Enter subject name";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10),
                                child: DropdownButtonFormField<String?>(
                                  hint: const Text("Select Year"),
                                  isExpanded: true,
                                  value: selectedyear,
                                  items: years.keys.map((e) {
                                    return DropdownMenuItem<String?>(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    if (value != selectedyear) {
                                      setState(() {
                                        selectedyear = value!;
                                        selectedsem = years[selectedyear]![0];
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10),
                                child: DropdownButtonFormField<String?>(
                                    hint: const Text("Select Sem"),
                                    isExpanded: true,
                                    value: selectedsem,
                                    items: (years[selectedyear] ?? []).map((e) {
                                      return DropdownMenuItem<String?>(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != selectedsem) {
                                        setState(() {
                                          selectedsem = val!;
                                        });
                                      }
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("Cancel", style: TextStyle(color: Colors.indigo[300]))),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                      onPressed: () {
                        if (rec.currentState!.validate()) {
                          if (!records.containsKey('Subjects')) {
                            records['Subjects'] = {};
                          }
                          records['Subjects'][subjectNamecontroller.text.toString().trim()] = {
                            "branch": branch.toString().trim(),
                            "year": selectedyear.toString()
                          };
                          FirebaseFirestore.instance.collection('Faculty_Detail').doc(name).set(records, SetOptions(merge: true));
                          var state = StoreProvider.of<AppState>(context).state;

                          Map<String, dynamic> record = state.subject;
                          record[subjectNamecontroller.text.toString().trim()] = {
                            "branch": branch.toString().trim(),
                            "year": selectedyear.toString()
                          };

                          StoreProvider.of<AppState>(context).dispatch(FetchData(subject: record));
                          setState(() {
                            Navigator.of(context).pop(true);
                          });
                        }
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.indigo[300]),
                      ))
                ],
              );
            })).then((value) => value != null && value ? true : false);
  }
}
