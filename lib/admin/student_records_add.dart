// ignore: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:campus_subsystem/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class StudentRecordAdd extends StatefulWidget {
  const StudentRecordAdd({Key? key}) : super(key: key);

  @override
  State<StudentRecordAdd> createState() => _StudentRecordAddState();
}

class _StudentRecordAddState extends State<StudentRecordAdd> {
  final fkey = GlobalKey<FormState>();

  Map<String, dynamic> records = {};
  double total = 0;
  bool clicked = false;
  String filename = '';

  TextEditingController branchcontroller = TextEditingController();
  TextEditingController markscontroller = TextEditingController();
  // List<Map<String, dynamic>> b = [];

  String selectedyear = '';
  String selectedsem = '';

  Map<String, List<String>> years = {
    'FY': ['1', '2'],
    'SY': ['3', '4'],
    'TY': ['5', '6'],
    'BE': ['7', '8'],
  };

  // onYearChanged(String? value) {
  //   //dont change second dropdown if 1st item didnt change
  //   if (value != selectedyear) {
  //     setState(() {
  //       selectedyear = value!;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
                // a.addAll(b);
                print("hello:::::::: ${records.length} $records");
                setState(() => clicked = true);
                if (fkey.currentState!.validate()) {
                  // marks['time'] = DateTime.now();
                  if (await showDialogConfirmation()) {
                    FirebaseFirestore inst = FirebaseFirestore.instance;
                    print("valid");
                    DocumentReference branchref = inst.collection("College").doc(branchcontroller.text);
                    await branchref.set({'exist': true});
                    await branchref.collection(selectedyear).doc("Syllabus").set({'exist': true});
                    await branchref.collection(selectedyear).doc("Attendance").set({'exist': true});
                    await branchref.collection(selectedyear).doc("Result").set({'exist': true});
                    records.forEach((key, value) {
                      print(key + value.toString());
                      inst.collection("Student_Detail").doc(key).set(value, SetOptions(merge: true));
                      print(branchcontroller.text + selectedyear);
                      branchref
                          .collection(selectedyear)
                          .doc("Roll_No")
                          .set({value["Roll_No"]: inst.doc("Student_Detail/${value['PRN']}")}, SetOptions(merge: true));
                    });
                    records.clear();
                    filename = '';
                    print(records);
                  }
                }

                setState(() => clicked = false);
                // Navigator.of(context).pop();
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
                          "Branch",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: branchcontroller,
                              onTapOutside: (_) async {
                                records.forEach((key, value) {
                                  records[key]['Branch'] = branchcontroller.text;
                                });
                                setState(() {});
                              },
                              validator: (name) {
                                if (name == null || name.isEmpty) {
                                  return '* Enter Branch';
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
                      children: [
                        const Expanded(
                            child: Text(
                          "Year",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10),
                                child: DropdownButtonFormField<String?>(
                                    hint: const Text("Select"),
                                    //underline: Container(),
                                    isExpanded: true,
                                    value: selectedyear.isNotEmpty ? selectedyear : selectedyear = years.keys.elementAt(0),
                                    // hint: const Text('Select.'),
                                    decoration:
                                        const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(color: Colors.white)),
                                    style: TextStyle(fontSize: 20, color: Colors.indigo[300], overflow: TextOverflow.ellipsis),
                                    icon: const Icon(Icons.arrow_drop_down_rounded),
                                    // iconSize: 40,
                                    elevation: 0,
                                    // value: selectedsubject.isEmpty ? null : selectedsubject,
                                    iconEnabledColor: Colors.green,
                                    // alignment: AlignmentDirectional.center,
                                    items: years.keys.map((e) {
                                      return DropdownMenuItem<String?>(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != selectedyear) {
                                        setState(() {
                                          selectedyear = value!;
                                          selectedsem = years[selectedyear]![0];
                                        });
                                      }
                                    }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                            child: Text(
                          "Sem",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10),
                                child: DropdownButtonFormField<String?>(
                                    hint: const Text("Select"),
                                    isExpanded: true,
                                    decoration:
                                        const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(color: Colors.white)),
                                    style: TextStyle(fontSize: 20, color: Colors.indigo[300], overflow: TextOverflow.ellipsis),
                                    icon: const Icon(Icons.arrow_drop_down_rounded),
                                    elevation: 0,
                                    iconEnabledColor: Colors.green,
                                    iconDisabledColor: Colors.red,
                                    value: selectedsem.isNotEmpty ? selectedsem : selectedsem = years[selectedyear]![0],
                                    items: years[selectedyear]?.map((e) {
                                      return DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (selectedsem != val) {
                                        setState(() {
                                          selectedsem = val!;
                                        });
                                      }
                                    }),
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
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: FloatingActionButton.extended(
                            heroTag: null,
                            onPressed: () {
                              // FilePickerResult? result =
                              int count = 0;
                              Map<String, int> m = {};
                              FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowMultiple: false,
                                  allowedExtensions: ["xlsx", "xls", "xlsm"]).then((result) {
                                if (result != null) {
                                  filename = '';
                                  File file = File(result.files.single.path.toString());
                                  // print(file.readAsBytesSync().toList().runtimeType.toString());
                                  var ex = Excel.decodeBytes(file.readAsBytesSync().toList());
                                  if (ex.tables.isNotEmpty) {
                                    String sheet = ex.tables.keys.single;
                                    if (ex.tables[sheet]!.maxCols == 9) {
                                      for (var row in ex.tables[sheet]!.rows) {
                                        if (count == 0) {
                                          for (int i = 0; i < ex.tables[sheet]!.maxCols; i++) {
                                            if (RegExp('.*roll.*', caseSensitive: false).hasMatch(row[i]!.value.toString())) {
                                              m['Roll_No'] = i;
                                            } else if (RegExp('.*prn.*', caseSensitive: false).hasMatch(row[i]!.value.toString())) {
                                              m['PRN'] = i;
                                            } else if (RegExp('.*address.*', caseSensitive: false)
                                                .hasMatch(row[i]!.value.toString())) {
                                              m['Address'] = i;
                                            } else if (RegExp('.*email.*', caseSensitive: false).hasMatch(row[i]!.value.toString())) {
                                              m['Email'] = i;
                                            } else if (RegExp('.*first.*', caseSensitive: false).hasMatch(row[i]!.value.toString())) {
                                              m['First'] = i;
                                            } else if (RegExp('.*middle.*', caseSensitive: false).hasMatch(row[i]!.value.toString())) {
                                              m['Middle'] = i;
                                            } else if (RegExp('.*last.*', caseSensitive: false).hasMatch(row[i]!.value.toString())) {
                                              m['Last'] = i;
                                            } else if (RegExp('.*DOB.*|.*date.*|.*birth.*', caseSensitive: false)
                                                .hasMatch(row[i]!.value.toString())) {
                                              m['DOB'] = i;
                                            } else if (RegExp('.*mob.*|.*phone.*|.*whatsapp.*|', caseSensitive: false)
                                                .hasMatch(row[i]!.value.toString())) {
                                              m['Mobile'] = i;
                                            }

                                            // print(RegExp(".*last.*", caseSensitive: false).hasMatch(row[i]!.value.toString()));
                                          }
                                          count += 1;
                                          // print(m);
                                        } else {
                                          if (m.length == 9) {
                                            Map<String, dynamic> studentDetail = {};

                                            if (row[m['Mobile']!]?.value.toString() != null &&
                                                row[m['First']!]?.value.toString() != null &&
                                                row[m['Middle']!]?.value.toString() != null &&
                                                row[m['Last']!]?.value.toString() != null &&
                                                row[m['Email']!]?.value.toString() != null &&
                                                row[m['PRN']!]?.value.toString() != null &&
                                                row[m['DOB']!]?.value.toString() != null &&
                                                row[m['Address']!]?.value.toString() != null) {
                                              String? fName = row[m['First']!]!.value.toString();
                                              String? mName = row[m['Middle']!]?.value.toString();
                                              String? lName = row[m['Last']!]!.value.toString();

                                              studentDetail["Roll_No"] = row[m['Roll_No']!]!.value.toString();
                                              studentDetail["Name"] = {"First": fName, "Middle": mName, "Last": lName};

                                              studentDetail["Address"] = row[m['Address']!]?.value.toString();
                                              studentDetail["PRN"] = row[m['PRN']!]?.value.toString();
                                              studentDetail["DOB"] =
                                                  DateFormat('dd MMM yyyy').format(DateTime.parse(row[m['DOB']!]!.value.toString()));
                                              studentDetail['Branch'] = branchcontroller.text.toString();
                                              studentDetail["Email"] = row[m['Email']!]?.value.toString();
                                              records[studentDetail["PRN"]] = studentDetail;
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text(
                                                "There is conflict in reading excel sheet.Make sure there is no column with same name.",
                                                maxLines: 3,
                                              ),
                                              duration: Duration(seconds: 5),
                                            ));
                                          }
                                          //address != null && DOB != null && email != null
                                        }
                                      }

                                      setState(() => filename = result.files.single.name);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(content: Text("More or less than 9 columns present.")));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No table found")));
                                  }
                                } else {
                                  // User canceled the picker
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File not selected")));
                                }
                                setState(() {
                                  FilePicker.platform.clearTemporaryFiles();
                                });
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
                        IconButton(
                            iconSize: 30,
                            tooltip: "How to upload excel sheet.",
                            onPressed: () {
                              showDialogHelp();
                            },
                            icon: const Icon(
                              Icons.help_outline,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shadowColor: Colors.indigo[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Records : ${records.length}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[300], fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: records.length + 1,
                    itemBuilder: (context, index) {
                      List temp = records.keys.toList();
                      temp.sort();
                      //int key = index == b.length ? -1 : temp.elementAt(index);

                      if (index == records.length) {
                        int? r;
                        return Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.indigo[200]),
                          margin: const EdgeInsets.all(10),
                          child: Center(
                            child: IconButton(
                              color: Colors.white,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.add),
                              onPressed: () async {
                                if (fkey.currentState!.validate()) {
                                  await showDialogAddNew();
                                  setState(() {});
                                }

                                // if (r != null) {
                                //   setState(() {
                                //     records[r!] = 0;
                                //   });
                                // }
                                // showDialogAddNew();
                              },
                            ),
                          ),
                        );
                      } else {
                        return Stack(
                          children: [
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.indigo[200]),
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "${records[temp[index]]["PRN"].toString()} :",
                                        // textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        getName(records[temp[index]]["Name"]).toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        // textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                showDialogDetail(temp[index]);
                              },
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
                                  records.remove(temp[index]);
                                }),
                              ),
                            )
                          ],
                        );
                      }
                    },
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.3),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
                    Image.asset("assets/images/student_excel.png"),
                    Container(
                        margin: const EdgeInsets.all(5),
                        child: const Text(
                            "1. Add 9 column as shown in image.\n2. All columns are required as it will be used to fill data in database.\n3. Don't provide empty cells otherwise they will get ignored."))
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

  showDialogDetail(String index) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              title: Text(
                index.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(5),
                  child: Text(
                      "Name : ${getName(records[index]['Name'])}\nBranch : ${records[index]['Branch'].toString()}\nRoll.no : ${records[index]['Roll_No'].toString()}\nEmail : ${records[index]['Email'].toString()}\nAddress : ${records[index]['Address'].toString()}\nDOB : ${records[index]['DOB'].toString()}")),
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

  Future<bool> showDialogConfirmation() async {
    return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              title: const Text(
                "Confirm",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(margin: const EdgeInsets.all(5), child: const Text("Do you want to add to Database.")),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo[300]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () => Navigator.of(context).pop<bool>(true),
                    child: const Text("Yes")),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo[300]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("No"))
              ],
            )).then((value) {
      return value != null && value ? true : false;
    });
  }

  showDialogAddNew() {
    final rec = GlobalKey<FormState>();
    TextEditingController rollcontroller = TextEditingController();
    TextEditingController namecontroller1 = TextEditingController();
    TextEditingController namecontroller2 = TextEditingController();
    TextEditingController namecontroller3 = TextEditingController();
    TextEditingController prncontroller = TextEditingController();
    TextEditingController addresscontroller = TextEditingController();
    TextEditingController emailcontroller = TextEditingController();
    String date = '';
    Map<String, dynamic> record = {};
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.indigo[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                alignment: Alignment.center,
                title: const Text(
                  "Add Record",
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
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: TextFormField(
                              controller: prncontroller,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              // initialValue: marks[key].toString(),
                              decoration: InputDecoration(
                                // focusColor: Colors.black,
                                errorStyle: const TextStyle(color: Colors.white),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'PRN',
                              ),
                              validator: (key) {
                                // if (key == null || key.isEmpty) {
                                //   return "Add roll";
                                // }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: TextFormField(
                              controller: rollcontroller,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              // initialValue: marks[key].toString(),
                              decoration: InputDecoration(
                                // focusColor: Colors.black,
                                errorStyle: const TextStyle(color: Colors.white),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Roll',
                              ),
                              validator: (key) {
                                // if (key == null || key.isEmpty) {
                                //   return "Add roll";
                                // }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: TextFormField(
                              controller: namecontroller1,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              // initialValue: marks[key].toString(),
                              decoration: InputDecoration(
                                // focusColor: Colors.black,
                                errorStyle: const TextStyle(color: Colors.white),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'First Name',
                              ),
                              validator: (key) {
                                if (key == null || key.isEmpty) {
                                  return "Add first name";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: TextFormField(
                              controller: namecontroller2,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              // initialValue: marks[key].toString(),
                              decoration: InputDecoration(
                                // focusColor: Colors.black,
                                errorStyle: const TextStyle(color: Colors.white),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Middle Name',
                              ),
                              validator: (key) {
                                if (key == null || key.isEmpty) {
                                  return "Add middle name";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: TextFormField(
                              controller: namecontroller3,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              // initialValue: marks[key].toString(),
                              decoration: InputDecoration(
                                // focusColor: Colors.black,
                                errorStyle: const TextStyle(color: Colors.white),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Last Name',
                              ),
                              validator: (key) {
                                if (key == null || key.isEmpty) {
                                  return "Add last name";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: TextFormField(
                              controller: addresscontroller,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              // initialValue: marks[key].toString(),
                              decoration: InputDecoration(
                                // focusColor: Colors.black,
                                errorStyle: const TextStyle(color: Colors.white),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Address',
                              ),
                              validator: (key) {
                                if (key == null || key.isEmpty) {
                                  return "Add roll";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: TextFormField(
                              controller: emailcontroller,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              // initialValue: marks[key].toString(),
                              decoration: InputDecoration(
                                // focusColor: Colors.black,
                                errorStyle: const TextStyle(color: Colors.white),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Email',
                              ),
                              validator: (key) {
                                if (key != null) {
                                  if (key.length > 5 && key.contains('@') && key.endsWith('.com')) {
                                    return null;
                                  }
                                  return 'Enter a Valid Email Address';
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                            child: FloatingActionButton.extended(
                                backgroundColor: Colors.white,
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.indigo[300],
                                ),
                                onPressed: () async {
                                  await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          lastDate: DateTime.now(),
                                          firstDate: DateTime(1990))
                                      .then((value) {
                                    if (value != null) {
                                      setState(() {
                                        date = DateFormat('dd MMM yyyy').format(value);
                                      });
                                    }
                                  });
                                },
                                label: Text(
                                  date.isEmpty ? "DOB" : date,
                                  style: TextStyle(color: Colors.indigo[300]),
                                )),
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
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel", style: TextStyle(color: Colors.indigo[300]))),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                      onPressed: () {
                        if (rec.currentState!.validate()) {
                          record = {};
                          record["Branch"] = branchcontroller.text.toString();
                          record["Year"] = selectedyear;
                          record["Sem"] = selectedsem;
                          record["Roll"] = rollcontroller.text.toString();
                          record["Name"] = {};
                          record["Name"]['First'] = namecontroller1.text.toString();
                          record["Name"]['Last'] = namecontroller3.text.toString();
                          record["Name"]['Middle'] = namecontroller2.text.toString();
                          record["PRN"] = prncontroller.text.toString();
                          record["Address"] = addresscontroller.text.toString();
                          record["Email"] = emailcontroller.text.toString();
                          record["DOB"] = date;
                          // Map<String, dynamic> t = {};
                          records[record["PRN"]] = record;
                          // b.add(t);

                          print(records);
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        }
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.indigo[300]),
                      ))
                ],
              );
            }));
  }

  getName(Map<String, String?> name) {
    return "${name['First'].toString().capitalize()} ${name['Middle'].toString().capitalize()} ${name['Last'].toString().capitalize()}";
  }

  // void addForStudents(CollectionReference reference, name) async {
  //   print(marks);
  //
  //   reference.doc("Roll_No").get().then((docsnap) {
  //     (docsnap.data()! as Map<String, dynamic>).forEach((roll, ref) {
  //       marks.containsKey(int.parse(roll))
  //           ? ref.collection("Result").doc(selectedsub).set({
  //               namecontroller.text: {"mark": marks[int.parse(roll)], "total": total, 'time': DateTime.now()},
  //             }, SetOptions(merge: true))
  //           : null;
  //     });
  //   });
  // }
}
