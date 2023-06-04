// ignore: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:campus_subsystem/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FacultyRecordsAdd extends StatefulWidget {
  const FacultyRecordsAdd({Key? key}) : super(key: key);

  @override
  State<FacultyRecordsAdd> createState() => _FacultyRecordsAddState();
}

class _FacultyRecordsAddState extends State<FacultyRecordsAdd> {
  String selectedsub = "";
  TextEditingController batchcontroller = TextEditingController();
  TextEditingController facultyDetailcontroller = TextEditingController();
  TextEditingController rollcontroller = TextEditingController();

  final fkey = GlobalKey<FormState>();

  Map<String, dynamic> records = {};
  double total = 0;
  bool clicked = false;
  String filename = '';

  List<Map<String, dynamic>> b = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: clicked
          ? FloatingActionButton(
              onPressed: null,
              backgroundColor: Colors.indigo[200],
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
                print("hello:::::::: ${records.length} $records");
                setState(() => clicked = true);
                if (fkey.currentState!.validate()) {
                  if (records.isNotEmpty) {
                    if (await showDialogConfirmation()) {
                      FirebaseFirestore inst = FirebaseFirestore.instance;
                      print("valid");
                      records.forEach((key, value) {
                        value.addAll({'Branch': batchcontroller.text.trim()});
                        print(key + value.toString());
                        inst.collection("Faculty_Detail").doc(key).set(value, SetOptions(merge: true));
                      });
                      records.clear();
                      filename = '';
                      print(records);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No Records found to Upload")));
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
          "Add Faculty User",
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
                              controller: batchcontroller,
                              validator: (name) {
                                if (name == null || name.isEmpty) {
                                  return '* Enter Batch';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: FloatingActionButton.extended(
                            heroTag: null,
                            onPressed: () {
                              int count = 0;
                              Map<String, int> m = {};
                              FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowMultiple: false,
                                  allowedExtensions: ["xlsx", "xls", "xlsm"]).then((result) {
                                if (result != null) {
                                  filename = '';
                                  File file = File(result.files.single.path.toString());
                                  print(file.readAsBytesSync().toList().runtimeType.toString());
                                  var ex = Excel.decodeBytes(file.readAsBytesSync().toList());
                                  if (ex.tables.isNotEmpty) {
                                    String sheet = ex.tables.keys.single;
                                    if (ex.tables[sheet]!.maxCols == 5) {
                                      for (var row in ex.tables[sheet]!.rows) {
                                        if (count == 0) {
                                          for (int i = 0; i < ex.tables[sheet]!.maxCols; i++) {
                                            if (RegExp('.*email.*', caseSensitive: false).hasMatch(row[i]!.value.toString())) {
                                              m['Email'] = i;
                                            } else if (RegExp('.*first.*', caseSensitive: false).hasMatch(row[i]!.value.toString())) {
                                              m['First'] = i;
                                            } else if (RegExp('.*middle.*', caseSensitive: false).hasMatch(row[i]!.value.toString())) {
                                              m['Middle'] = i;
                                            } else if (RegExp('.*last.*', caseSensitive: false).hasMatch(row[i]!.value.toString())) {
                                              m['Last'] = i;
                                            } else if (RegExp('.*mob.*|.*phone.*|.*whatsapp.*|', caseSensitive: false)
                                                .hasMatch(row[i]!.value.toString())) {
                                              m['Mobile'] = i;
                                            }
                                          }

                                          count += 1;
                                        } else {
                                          Map<String, dynamic> facultyDetail = {};
                                          if (row[m['Mobile']!]?.value.toString() != null &&
                                              row[m['First']!]?.value.toString() != null &&
                                              row[m['Middle']!]?.value.toString() != null &&
                                              row[m['Last']!]?.value.toString() != null &&
                                              row[m['Email']!]?.value.toString() != null) {
                                            String? mobile = row[m['Mobile']!]!.value.toString();
                                            String? fName = row[m['First']!]!.value.toString();
                                            String? mName = row[m['Middle']!]?.value.toString();
                                            String? lName = row[m['Last']!]!.value.toString();

                                            String? email = row[m['Email']!]?.value.toString();

                                            facultyDetail["Mobile"] = mobile;

                                            facultyDetail["Name"] = {"First": fName, "Middle": mName, "Last": lName};

                                            facultyDetail["Email"] = email;

                                            records[facultyDetail['Email']] = facultyDetail;
                                          }
                                        }
                                      }
                                      print(records);
                                      setState(() => filename = result.files.single.name);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("More or less than 5 columns present.\nSee HELP")));
                                      print("Columns more or less");
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No table found")));
                                    print("not table");
                                  }
                                } else {
                                  // User canceled the picker
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File not selected")));
                                  print("file not selected");
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
                    shrinkWrap: true,
                    itemCount: records.length + 1,
                    itemBuilder: (context, index) {
                      List temp = records.keys.toList();
                      temp.sort();

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
                                  await showDialogAddFaculty();
                                  print(records);
                                  setState(() {});
                                }
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${records[temp[index]]["Email"].toString()} :",
                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            getName(records[temp[index]]["Name"]).toString(),
                                            maxLines: 3,
                                            // overflow: TextOverflow.ellipsis,

                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'Subjects : ${records[temp[index]].containsKey('Subjects') ? records[temp[index]]['Subjects'].length : 0}'),
                                        IconButton(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          icon: const CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 8,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.green,
                                              size: 15,
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (await showDialogAddNewSubject(temp[index])) {
                                              print(records[temp[index]]);
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    records[temp[index]].containsKey('Subjects')
                                        ? Text("${records[temp[index]]['Subjects'].keys.toList().join(',')}")
                                        : Container()
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
                                  print(records);
                                }),
                              ),
                            ),
                          ],
                        );
                      }
                    },
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
                    Image.asset("assets/images/faculty_excel.png"),
                    Container(
                        margin: const EdgeInsets.all(5),
                        child: const Text(
                            "1. Add 5 column as shown in image.\n2. All columns are required as it will be used to fill data in database.\n3. Don't provide empty cells otherwise row will get ignored."))
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

  showDialogDetail(String name) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              title: Text(
                records[name].keys.elementAt(0).toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(5),
                        child: Text("Name : ${getName(records[name]['Name'])}"
                            "\nEmail : ${records[name]['Email'].toString()}"
                            "\nMobile : ${records[name]['Mobile'].toString()}"
                            "${records[name].containsKey('Subjects') ? "\nSubjects : ${records[name]['Subjects'].keys.join(',')}" : ""}")),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo[300]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK")),
              ],
            ));
  }

  Future<bool> showDialogAddNewSubject(String name) async {
    TextEditingController subjectNamecontroller = TextEditingController();

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
                          if (!records[name].containsKey('Subjects')) {
                            records[name]['Subjects'] = {};
                          }
                          records[name]['Subjects'][subjectNamecontroller.text.toString().trim()] = {
                            "Branch": batchcontroller.text.toString().trim(),
                            "Year": selectedyear.toString()
                          };

                          print(records[name]);
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

  showDialogAddFaculty() {
    final rec = GlobalKey<FormState>();
    TextEditingController firstcontroller = TextEditingController();
    TextEditingController lastcontroller = TextEditingController();
    TextEditingController middlecontroller = TextEditingController();
    TextEditingController mobilecontroller = TextEditingController();
    TextEditingController emailcontroller = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
                          child: TextFormField(
                            controller: firstcontroller,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.white),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'First Name',
                            ),
                            validator: (key) {
                              if (key == null || key.isEmpty) {
                                return "Enter first name";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: middlecontroller,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.white),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Middle Name',
                            ),
                            validator: (key) {
                              if (key == null || key.isEmpty) {
                                return "Enter Middle name";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: lastcontroller,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.white),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Last Name',
                            ),
                            validator: (key) {
                              if (key == null || key.isEmpty) {
                                return "Enter Last Name";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: emailcontroller,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.white),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Email',
                            ),
                            validator: (key) {
                              if (key != null && key.isNotEmpty) {
                                if (key.length < 7 && !key.startsWith('@') && !key.contains('@') && !key.endsWith('.com')) {
                                  return 'Enter a Valid Email Address';
                                } else {
                                  return null;
                                }
                              } else {
                                return 'Enter Email';
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: mobilecontroller,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.white),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Mobile',
                            ),
                            validator: (key) {
                              if (key == null || key.isEmpty) {
                                return "Enter Mobile number";
                              }
                              return null;
                            },
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancel", style: TextStyle(color: Colors.indigo[300]))),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () {
                      if (rec.currentState!.validate()) {
                        if (!records.containsKey(emailcontroller.text.trim())) {
                          records[emailcontroller.text.trim()] = <String, dynamic>{};
                        }
                        records[emailcontroller.text.trim()]["Email"] = emailcontroller.text.trim();
                        records[emailcontroller.text.trim()]["Mobile"] = mobilecontroller.text.trim();
                        records[emailcontroller.text.trim()]["Name"] = {
                          "First": firstcontroller.text.toString().trim(),
                          "Middle": middlecontroller.text.toString().trim(),
                          "Last": lastcontroller.text.toString().trim()
                        };

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

  getName(Map<String, String?> name) {
    return "${name['First'].toString().capitalize()} ${name['Middle'].toString().capitalize()} ${name['Last'].toString().capitalize()}";
  }
}
