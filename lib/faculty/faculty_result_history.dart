import 'package:campus_subsystem/faculty/faculty_result_add.dart';
import 'package:campus_subsystem/redux/reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FacultyResultHistory extends StatefulWidget {
  const FacultyResultHistory({Key? key}) : super(key: key);

  @override
  State<FacultyResultHistory> createState() => _FacultyResultHistoryState();
}

class _FacultyResultHistoryState extends State<FacultyResultHistory> {
  String selectedsubject = '';
  String selectedtest = '';
  List<String> tests = [];
  Map<String, dynamic> result = {};
  List rolls = [];
  double total = 0;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "History",
                style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.indigo[300],
            ),
            floatingActionButton: FloatingActionButton.extended(
              elevation: 1,
              heroTag: "tag",
              backgroundColor: Colors.indigo[200],
              foregroundColor: Colors.black,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FacultyResultAdd())),
              icon: const Icon(Icons.add),
              label: const Text(
                "Add New Result",
                style: TextStyle(fontFamily: 'MuliBold', fontSize: 20),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // height: 50,
                    color: Colors.indigo[300],
                    // decoration: BoxDecoration(color: Colors.indigo[300], border: const Border(top: BorderSide(color: Colors.black))),
                    child: Column(
                      children: [
                        // select subject
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                                child: Text(
                              "Subject",
                              style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                margin: const EdgeInsets.all(20),
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: const Text('Select.'),
                                      style: TextStyle(fontSize: 20, color: Colors.indigo[300], overflow: TextOverflow.ellipsis),
                                      icon: const Icon(Icons.arrow_drop_down_rounded),
                                      // iconSize: 40,
                                      elevation: 0,
                                      value: selectedsubject.isEmpty ? null : selectedsubject,
                                      iconEnabledColor: Colors.green,
                                      // alignment: AlignmentDirectional.center,
                                      items: state.subject.keys
                                          .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              ))
                                          .toList(),
                                      onChanged: (String? value) async {
                                        if (value != selectedsubject) {
                                          rolls = [];
                                          result.clear();
                                          selectedtest = '';
                                          selectedsubject = value!;
                                          await getResult(state.subject[selectedsubject]);
                                         
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // select test
                        Row(
                          children: [
                            const Expanded(
                                child: Text(
                              "Date",
                              style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 3,
                              child: selectedsubject.isNotEmpty
                                  ? Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                      margin: const EdgeInsets.all(20),
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                              elevation: 0,
                                              isExpanded: true,
                                              style:
                                                  TextStyle(fontSize: 20, color: Colors.indigo[200], overflow: TextOverflow.ellipsis),
                                              icon: const Icon(Icons.arrow_drop_down_rounded),
                                              // iconSize: 40,
                                              iconEnabledColor: Colors.green,
                                              iconDisabledColor: Colors.red,
                                              value: selectedtest,
                                              alignment: AlignmentDirectional.centerStart,
                                              hint: Text(
                                                tests.isNotEmpty ? "Select." : "No Records added.",
                                                textAlign: TextAlign.start,
                                              ),
                                              items: tests.isNotEmpty
                                                  ? tests.map<DropdownMenuItem<String>>((value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value.toString(),
                                                        child: Text(value,
                                                            style: const TextStyle(fontSize: 20, overflow: TextOverflow.ellipsis),
                                                            textAlign: TextAlign.center),
                                                      );
                                                    }).toList()
                                                  : null,
                                              onChanged: (String? value) => value != selectedtest
                                                  ? setState(() {
                                                      selectedtest = value!;
                                                      rolls = getRolls();
                                                      rolls.sort();
                                                    })
                                                  : null),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.indigo[300],
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                        margin: const EdgeInsets.all(20),
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                hint: const Text('Select.'),
                                                elevation: 0,
                                                style: TextStyle(
                                                    fontSize: 20, color: Colors.indigo[200], overflow: TextOverflow.ellipsis),
                                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                                // iconSize: 40,
                                                iconDisabledColor: Colors.red,
                                                alignment: AlignmentDirectional.center,
                                                // hint: const Text("Select date."),
                                                items: null,
                                                onChanged: null),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  selectedtest.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(selectedtest,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            IconButton(
                                onPressed: () => showDialogDelete(state.subject),
                                icon: const Icon(
                                  Icons.delete_forever_rounded,
                                  size: 30,
                                  color: Colors.redAccent,
                                ))
                          ],
                        )
                      : Container(),

                  Expanded(
                    child: result.isNotEmpty && selectedtest.isNotEmpty && result[selectedtest].isNotEmpty
                        ? GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2),
                            itemCount: rolls.length,
                            itemBuilder: (context, int index) {
                              int key = rolls[index];
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: (result[selectedtest][key]) * 100 / total >= 35 ? Colors.green[200] : Colors.red[200]),
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$key :  ",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${result[selectedtest][key]}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Container(),
                  ),
                  // ElevatedButton(
                  //     onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FacultyResultAdd())),
                  //     child: const Text("Add result")),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> getResult(Map<String, dynamic> subject) async {
    QuerySnapshot resultSnap = await FirebaseFirestore.instance
        .collection("College/${subject['branch']}/${subject['year']}/Results/$selectedsubject")
        .orderBy('time', descending: true)
        .get();
    tests = resultSnap.docs.map((e) {
      Map temp = (e.data() as Map<String, dynamic>);
      temp.remove('time');
      total = temp.remove('total');
      result[e.id] = temp.map((key, value) {
        return MapEntry(int.parse(key), (value));
      });
      return e.id;
    }).toList();
    if (tests.isNotEmpty) {
      selectedtest = tests[0];
      rolls = getRolls();
      rolls.sort();
    }
  }

  List getRolls() {
    return result[selectedtest].keys.toList();
  }

  showDialogDelete(subject) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              title: const Text(
                "Delete",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(margin: const EdgeInsets.all(5), child: const Text("Do you want to delete Test Result of ")),
                    Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          "$selectedtest ?",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ))
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo[300]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      CollectionReference ref = await FirebaseFirestore.instance
                          .collection("College/${subject[selectedsubject]['branch']}/${subject[selectedsubject]['year']}");
                      ref
                          .doc("Results/$selectedsubject/$selectedtest")
                          .delete()
                          .onError((error, stackTrace) => null)
                          .then((_) {
                        deleteForEveryStudent(ref);
                        setState(() {
                          // selectedsubject = '';
                          selectedtest = '';
                          tests = [];
                          result = {};
                          rolls = [];
                          total = 0;
                        });
                      });
                    },
                    child: const Text("Yes")),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo[300]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("No"))
              ],
            ));
  }

  void deleteForEveryStudent(CollectionReference reference) {
    reference.doc("Roll_No").get().then((docsnap) {
      (docsnap.data()! as Map<String, dynamic>).forEach((roll, ref) {
        try {
          ref.collection('Result').doc(selectedsubject).update({selectedtest: FieldValue.delete()});
        } on FirebaseException catch (e) {}
      });
    });
  }
}
