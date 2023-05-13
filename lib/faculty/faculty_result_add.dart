import 'dart:io';
import 'package:campus_subsystem/redux/reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

  Map<int, int> marks = {};
  bool clicked = false;

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
                      print(marks);
                      if (fkey.currentState!.validate()) {
                        // marks['time'] = DateTime.now();
                        print("valid");
                        Map<String, dynamic> temp = marks.map((key, value) => MapEntry(key.toString(), value));
                        temp['total'] = double.parse(markscontroller.text);
                        temp['time'] = DateTime.now();
                        marks.isNotEmpty && namecontroller.text.isNotEmpty && selectedsub.isNotEmpty
                            ? FirebaseFirestore.instance
                                .collection("/College/${state.subject[selectedsub]['branch']}/${state.subject[selectedsub]['year']}")
                                .doc("Results")
                                .collection(selectedsub)
                                .doc(namecontroller.text)
                                .set(temp, SetOptions(merge: true))
                                .onError((error, stackTrace) => print("$error   $stackTrace"))
                            : print(
                                "/College/${state.subject[selectedsub]['branch']}/${state.subject[selectedsub]['year']}/Results/$selectedsub");
                      }
                      print(
                          "/College/${state.subject[selectedsub]['branch']}/${state.subject[selectedsub]['year']}/Results/$selectedsub");
                      // var ref = FirebaseFirestore.instance.collection("/College/${state.subject[selectedsub]['branch']}/${state.subject[selectedsub]['year']}");
                    },
                    icon: const Icon(Icons.done_outline_rounded),
                    label: const Text(
                      "Submit",
                      style: TextStyle(fontFamily: 'MuliBold', fontSize: 20),
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
                                      iconSize: 20,
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
                                        print(newvalue);
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
                                    validator: (name) {
                                      if (name == null || name.isEmpty) {
                                        return '* Total Marks';
                                      }
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
                                    onPressed: () async {
                                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                                          type: FileType.custom, allowMultiple: false, allowedExtensions: ["xlsx", "xls", "xlsm"]);

                                      if (result != null) {
                                        // print(result.files.single.path);
                                        File file = File(result.files.single.path.toString());
                                        print(file.readAsBytesSync().toList().runtimeType.toString());
                                        var ex = Excel.decodeBytes(file.readAsBytesSync().toList());
                                        if (ex.tables.isNotEmpty) {
                                          String sheet = ex.tables.keys.single;
                                          if (ex.tables[sheet]!.maxCols == 2) {
                                            for (var element in ex.tables[sheet]!.rows) {
                                              int? key = int.tryParse(element[0]!.value.toString());
                                              int? value = int.tryParse(element[1]!.value.toString());
                                              if (key != null && value != null) {
                                                marks[key] = value;
                                              }
                                            }

                                            // todo show to user
                                            setState(() {});

                                            // todo add to firebase
                                          } else {
                                            print("Columns more or less");
                                          }
                                        } else {
                                          print("not table");
                                        }
                                        print(marks);
                                      } else {
                                        // User canceled the picker
                                        print("file not selected");
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                    ),
                                    label: const Text(
                                      "Add Excel File",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                    itemCount: marks.length,
                    itemBuilder: (context, index) {
                      int key = marks.keys.elementAt(index);
                      // int prev = marks[index]!;
                      return Container(
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
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 23),
                                  keyboardType: TextInputType.number,
                                  initialValue: marks[key].toString(),
                                  decoration: InputDecoration(
                                    // focusColor: Colors.black,
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    focusedBorder:
                                        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: 'Name',
                                  ),
                                  onChanged: (value) {
                                    marks[key] = int.parse(value);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.5),
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
}
