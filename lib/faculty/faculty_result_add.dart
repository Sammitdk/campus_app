import 'dart:io';
import 'package:campus_subsystem/firebase/notification.dart';
import 'package:campus_subsystem/redux/reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:excel/excel.dart';

class FacultyResultAdd extends StatefulWidget {
  const FacultyResultAdd({Key? key}) : super(key: key);

  @override
  State<FacultyResultAdd> createState() => _FacultyResultAddState();
}

class _FacultyResultAddState extends State<FacultyResultAdd> {
  String selectedsub = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController markscontroller = TextEditingController();

  final fkey = GlobalKey<FormState>();

  Map<int, double> marks = {};
  double total = 0;
  bool clicked = false;
  String filename = '';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: clicked
                ? FloatingActionButton(
                    onPressed: null,
                    backgroundColor: Colors.indigo[200],
                    // foregroundColor: Colors.black,
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
                  )
                : FloatingActionButton.extended(
                    elevation: 1,
                    heroTag: "tag",
                    backgroundColor: Colors.indigo[200],
                    foregroundColor: Colors.black,
                    onPressed: () async {
                      setState(() => clicked = true);
                      if (fkey.currentState!.validate()) {
                        // marks['time'] = DateTime.now();

                        Map<String, dynamic> temp = marks.map((key, value) => MapEntry(key.toString(), value));
                        temp['total'] = total = double.parse(markscontroller.text);
                        temp['time'] = DateTime.now();
                        if (marks.isNotEmpty) {
                          CollectionReference branchyear = FirebaseFirestore.instance
                              .collection("/College/${state.subject[selectedsub]['branch']}/${state.subject[selectedsub]['year']}");
                          branchyear
                              .doc("Results/$selectedsub/${namecontroller.text}")
                              .set(temp, SetOptions(merge: true))
                              .onError((error, stackTrace) => null);
                          addForStudents(branchyear);
                        }
                      }

                      setState(() => clicked = false);
                    },
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Submit",
                      style: TextStyle(fontFamily: 'MuliBold', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Add Result",
                style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.indigo[300],
            ),
            body: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.indigo[300]),
                    child: Form(
                      key: fkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                  child: Text(
                                "Test",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                                textAlign: TextAlign.center,
                              )),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: namecontroller,
                                    validator: (name) {
                                      if (name == null || name.isEmpty) {
                                        return '* Enter Name of Test';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      // focusColor: Colors.black,
                                      errorStyle: const TextStyle(color: Colors.white),
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      focusedBorder:
                                          OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'Name',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                  child: Text(
                                "Subject",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                                textAlign: TextAlign.center,
                              )),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                  margin: const EdgeInsets.all(10),
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButtonFormField<String>(
                                      decoration:
                                          const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(color: Colors.white)),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Select Subject.';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.indigo[300],
                                      ),
                                      icon: const Icon(Icons.arrow_drop_down_rounded),
                                      iconEnabledColor: Colors.green,
                                      alignment: AlignmentDirectional.center,
                                      value: selectedsub == "" ? selectedsub = state.subject.keys.elementAt(0) : selectedsub,
                                      items: state.subject.keys
                                          .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (newvalue) {
                                        if (newvalue != selectedsub) {
                                          setState(() {
                                            selectedsub = newvalue!;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Marks",
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    // style: const TextStyle(fontSize: 23),
                                    keyboardType: TextInputType.number,
                                    controller: markscontroller,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    validator: (name) {
                                      if (name == null || name.isEmpty) {
                                        return '* Total Marks';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(color: Colors.white),
                                      // focusColor: Colors.black,
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      focusedBorder:
                                          OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'Total',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  child: FloatingActionButton.extended(
                                    heroTag: null,
                                    onPressed: () {
                                      // FilePickerResult? result =
                                      FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowMultiple: false,
                                          allowedExtensions: ["xlsx", "xls", "xlsm"]).then((result) {
                                        if (result != null) {
                                          marks.clear();
                                          filename = '';
                                          File file = File(result.files.single.path.toString());

                                          var ex = Excel.decodeBytes(file.readAsBytesSync().toList());
                                          if (ex.tables.isNotEmpty) {
                                            String sheet = ex.tables.keys.single;
                                            if (ex.tables[sheet]!.maxCols == 2) {
                                              for (var element in ex.tables[sheet]!.rows) {
                                                int? key = int.tryParse(element[0]!.value.toString());
                                                double? value = double.tryParse(element[1]!.value.toString());
                                                if (key != null && value != null) {
                                                  marks[key] = value;
                                                }
                                              }

                                              setState(() => filename = result.files.single.name);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("More or less than 2 columns present.\nSee HELP")));
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(content: Text("No table found")));
                                          }
                                        } else {
                                          // User canceled the picker
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(content: Text("File not selected")));
                                        }
                                        setState(() {});
                                      });
                                    },
                                    icon: Icon(
                                      filename.isNotEmpty ? Icons.done : Icons.add,
                                      color: filename.isNotEmpty ? Colors.green[300] : Colors.black,
                                    ),
                                    label: Text(
                                      filename.isNotEmpty ? filename : "Add Excel File",
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                    iconSize: 30,
                                    tooltip: "How to upload excel sheet.",
                                    onPressed: () {
                                      showDialogHelp();
                                    },
                                    icon: const Icon(
                                      Icons.help_outline,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: marks.keys.length + 1,
                    itemBuilder: (context, index) {
                      List temp = marks.keys.toList();
                      temp.sort();
                      int key = index == marks.keys.length ? -1 : temp.elementAt(index);
                      // int prev = marks[index]!;
                      if (key == -1) {
                        int? r;
                        return Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.indigo[200]),
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (key) {
                                      if (key == null || key.isEmpty) {
                                        return "Empty.";
                                      } else if (marks.containsKey(int.parse(key))) {
                                        return "Exist.";
                                      }
                                      return null;
                                    },
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    decoration: InputDecoration(
                                        // focusColor: Colors.black,
                                        errorStyle: const TextStyle(fontSize: 10, color: Colors.white),
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        focusedBorder:
                                            OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                        border:
                                            OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Roll',
                                        labelStyle: const TextStyle(fontSize: 15)),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        r = int.parse(value);
                                      } else {
                                        r = null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                color: Colors.white,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  if (r != null) {
                                    setState(() {
                                      marks[r!] = 0;
                                    });
                                  }
                                  // showDialogAddNew();
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.indigo[200]),
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    key.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                                  )),

                                  // marks textfield
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                                      child: TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        controller: TextEditingController(text: marks[key].toString()),
                                        autofocus: false,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                                        validator: (key) {
                                          // key = key?.trim();
                                          if (key == null || key.isEmpty) {
                                            return "Empty";
                                          } else if (key.startsWith('.') || key.endsWith('.')) {
                                            return "Invalid";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          // focusColor: Colors.black,
                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                          focusedBorder:
                                              OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          border:
                                              OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          filled: true,
                                          fillColor: Colors.white,
                                          errorStyle: const TextStyle(fontSize: 10, color: Colors.white),
                                          // labelText: 'Name',
                                        ),
                                        onChanged: (value) {
                                          value = value.trim();
                                          if (value.isNotEmpty && !value.endsWith('.') && !value.startsWith('.')) {
                                            marks[key] = double.parse(value);
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 8,
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.red[300],
                                    size: 15,
                                  ),
                                ),
                                onPressed: () => setState(() {
                                  marks.remove(key);
                                }),
                              ),
                            )
                          ],
                        );
                      }
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.3),
                  )
                ],
              ),
            ),
          );
        });
  }

  showDialogHelp() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              title: const Text(
                "Help",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/excelDemo.png"),
                    Container(
                        margin: const EdgeInsets.all(5),
                        child: const Text(
                            "Add two columns, one for 'Rolls' and one for 'Marks'.\nThe marks will be uploaded to roll numbers only in 'Rolls' column."))
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo[300]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"))
              ],
            ));
  }

  // showDialogAddNew() {
  //   // Map<int,double> record = {};
  //   int? roll;
  //   double? mark;
  //   final rec = GlobalKey<FormState>();
  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             backgroundColor: Colors.indigo[300],
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  //             alignment: Alignment.center,
  //             title: const Text(
  //               "Add Record",
  //               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  //             ),
  //             content: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Form(
  //                 key: rec,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Expanded(
  //                       flex: 3,
  //                       child: Container(
  //                         margin: const EdgeInsets.all(10),
  //                         // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
  //                         child: TextFormField(
  //                           textAlignVertical: TextAlignVertical.center,
  //                           textAlign: TextAlign.center,
  //                           keyboardType: TextInputType.number,
  //                           // initialValue: marks[key].toString(),
  //                           decoration: InputDecoration(
  //                             // focusColor: Colors.black,
  //                             errorStyle: const TextStyle(color: Colors.white),
  //                             floatingLabelBehavior: FloatingLabelBehavior.never,
  //                             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
  //                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
  //                             filled: true,
  //                             fillColor: Colors.white,
  //                             labelText: 'Roll',
  //                           ),
  //                           validator: (key) {
  //                             if (key == null || key.isEmpty) {
  //                               return "Add roll";
  //                             }
  //                             return null;
  //                           },
  //                           onChanged: (key) {
  //                             // marks[key] = double.parse(value);
  //                             roll = int.parse(key);
  //                             // todo
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       flex: 3,
  //                       child: Container(
  //                         margin: const EdgeInsets.all(10),
  //                         // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
  //                         child: TextFormField(
  //                           textAlignVertical: TextAlignVertical.center,
  //                           textAlign: TextAlign.center,
  //                           keyboardType: TextInputType.number,
  //                           // initialValue: marks[key].toString(),
  //                           decoration: InputDecoration(
  //                             // focusColor: Colors.black,
  //                             errorStyle: const TextStyle(color: Colors.white),
  //                             floatingLabelBehavior: FloatingLabelBehavior.never,
  //                             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
  //                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
  //                             filled: true,
  //                             fillColor: Colors.white,
  //                             labelText: 'Mark',
  //                           ),
  //                           validator: (key) {
  //                             if (key == null || key.isEmpty) {
  //                               return "Add mark";
  //                             }
  //                             return null;
  //                           },
  //                           onChanged: (value) {
  //                             // todo
  //                             mark = double.parse(value);
  //                             // marks[key] = double.parse(value);
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             actions: [
  //               ElevatedButton(
  //                   style: ButtonStyle(
  //                       backgroundColor: MaterialStateProperty.all(Colors.white),
  //                       shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
  //                   onPressed: () => Navigator.of(context).pop(),
  //                   child: Text("Cancel", style: TextStyle(color: Colors.indigo[300]))),
  //               ElevatedButton(
  //                   style: ButtonStyle(
  //                       backgroundColor: MaterialStateProperty.all(Colors.white),
  //                       shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
  //                   onPressed: () {
  //                     // todo
  //                     if (rec.currentState!.validate()) {
  //                       marks[roll!] = mark!;
  //                       setState(() {
  //                         Navigator.of(context).pop();
  //                       });
  //                     }
  //                   },
  //                   child: Text(
  //                     "Add",
  //                     style: TextStyle(color: Colors.indigo[300]),
  //                   ))
  //             ],
  //           ));
  // }

  void addForStudents(CollectionReference reference) async {
    reference.doc("Roll_No").get().then((docsnap) {
      (docsnap.data()! as Map<String, DocumentReference>).forEach((roll, DocumentReference ref) {
        //todo notification
        ref.get().then((snap) {
          (snap.data()! as Map<String, dynamic>).containsKey("Token")
              ? NotificationAPI.postNotification(
                  title: "Result",
                  message: "Result of ${namecontroller.text.trim()} for subject $selectedsub is Uploaded",
                  receiver: (snap.data()! as Map<String, dynamic>)['Token'])
              : null;
        }).onError((error, stackTrace) => null);
        marks.containsKey(int.parse(roll))
            ? ref.collection("Result").doc(selectedsub).set({
                namecontroller.text.trim(): {"mark": marks[int.parse(roll)], "total": total, 'time': DateTime.now()},
              }, SetOptions(merge: true)).onError((error, stackTrace) => null)
            : null;
      });
    });
  }
}
