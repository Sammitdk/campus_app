// ignore: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FacultyAdd extends StatefulWidget {
  const FacultyAdd({Key? key}) : super(key: key);

  @override
  State<FacultyAdd> createState() => _FacultyAddState();
}

class _FacultyAddState extends State<FacultyAdd> {
  String selectedsub = "";
  TextEditingController batchcontroller = TextEditingController();
  TextEditingController facultyDetailcontroller = TextEditingController();
  TextEditingController rollcontroller = TextEditingController();

  final fkey = GlobalKey<FormState>();

  Map<String, dynamic> facultyDetail = {};

  List<Map> a = [];
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
                print("hello:::::::: $b");
                setState(() => clicked = true);
                if (fkey.currentState!.validate()) {
                  // facultyDetail['time'] = DateTime.now();
                  print("valid");
                  //Map<String, dynamic> temp = facultyDetail.map((key, value) => MapEntry(key.toString(), value));
                  // temp['total'] = total = double.parse(facultyDetailcontroller.text);
                  // temp['time'] = DateTime.now();
                  // if (facultyDetail.isNotEmpty) {
                  //   CollectionReference branchyear = FirebaseFirestore.instance
                  //       .collection("/College/${state.subject[selectedsub]['branch']}/${state.subject[selectedsub]['year']}");
                  //   branchyear
                  //       .doc("Results/$selectedsub/${namecontroller.text}")
                  //       .set(temp, SetOptions(merge: true))
                  //       .onError((error, stackTrace) => print("$error   $stackTrace"));
                  //   addForStudents(branchyear, namecontroller.text);
                  // }
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
                          "Batch",
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
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
                                    facultyDetail.clear();
                                    filename = '';
                                    File file = File(result.files.single.path.toString());
                                    print(file.readAsBytesSync().toList().runtimeType.toString());
                                    var ex = Excel.decodeBytes(file.readAsBytesSync().toList());
                                    if (ex.tables.isNotEmpty) {
                                      String sheet = ex.tables.keys.single;
                                      if (ex.tables[sheet]!.maxCols > 2) {
                                        for (var element in ex.tables[sheet]!.rows) {
                                          if (count == 0) {
                                            for (int i = 0; i < ex.tables[sheet]!.maxCols; i++) {
                                              if ('mobile' == element[i]!.value.toString().toLowerCase()) {
                                                m['mobile'] = i;
                                              }

                                              //RegExp("\\b('Email')\\b",
                                              //                                                       caseSensitive: false)
                                              //                                                   .hasMatch(element[i]!
                                              //                                                       .value
                                              //                                                       .toString())

                                              if ('email' == element[i]!.value.toString().toLowerCase()) {
                                                m['email'] = i;
                                              }

                                              if ('first' == element[i]!.value.toString().toLowerCase()) {
                                                m['first'] = i;
                                              }

                                              if ('middle' == element[i]!.value.toString().toLowerCase()) {
                                                m['middle'] = i;
                                              }

                                              if ('last' == element[i]!.value.toString().toLowerCase()) {
                                                m['last'] = i;
                                              }
                                              print(RegExp("\\b('Last')\\b", caseSensitive: false)
                                                  .hasMatch(element[i]!.value.toString()));

                                              print(element[i]!.value.toString());
                                            }
                                            print(m.keys.length);
                                            count += 1;
                                          } else {
                                            facultyDetail = {};
                                            print(m);
                                            if (element[m['mobile']!]?.value.toString() != null &&
                                                element[m['first']!]?.value.toString() != null &&
                                                element[m['middle']!]?.value.toString() != null &&
                                                element[m['last']!]?.value.toString() != null &&
                                                element[m['email']!]?.value.toString() != null) {
                                              String? mobile = element[m['mobile']!]!.value.toString();
                                              String? fName = element[m['first']!]!.value.toString();
                                              String? mName = element[m['middle']!]?.value.toString();
                                              String? lName = element[m['last']!]!.value.toString();

                                              String? email = element[m['email']!]?.value.toString();

                                              facultyDetail["Mobile"] = mobile;
                                              facultyDetail["Name"] = {"First": fName, "Middle": mName, "Last": lName};
                                              //facultyDetail['Branch'] = ;
                                              facultyDetail["Email"] = email;
                                              b.add(facultyDetail);
                                            }
                                            //address != null && DOB != null && email != null
                                          }
                                        }

                                        // todo show to user
                                        setState(() => filename = result.files.single.name);

                                        // todo add to firebase
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(content: Text("More or less than 2 columns present.")));
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
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              //physics: const NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: b.length + 1,
              itemBuilder: (context, index) {
                List temp = b.toList();
                //temp.sort();
                //int key = index == b.length ? -1 : temp.elementAt(index);

                if (index == b.length) {
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
                        onPressed: () {
                          showDialogAddFaculty();
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
                          child: Center(
                            child: Text(
                              b[index]['Mobile'].toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onTap: () {
                          showDialogDetail(index);
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
                            b.removeAt(index);
                          }),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                            // size: 15,
                          ),
                          onPressed: () => setState(() {
                            showDialogAddNew(index);
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
                    Image.asset("assets/images/excelDemo.png"),
                    Container(
                        margin: const EdgeInsets.all(5),
                        child: const Text(
                            "Add two columns, one for 'Rolls' and one for 'facultyDetail'.\nThe facultyDetail will be uploaded to roll numbers only in 'Rolls' column."))
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

  showDialogDetail(int index) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              title: Text(
                b[index].keys.elementAt(0).toString(),
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
                        child: Text("Name : ${b[index]['Name'].toString()}\nEmail : ${b[index]['Email'].toString()}\n")),
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
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo[300]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () => showDialogAddNew(index),
                    child: const Text("Add"))
              ],
            ));
  }

  showDialogAddNew(int index) {
    TextEditingController subjectNamecontroller = TextEditingController();

    String? selectedyear;
    String? selectedsem;

    Map<String, List<String>> dataset = {
      'FY': ['1', '2'],
      'SY': ['3', '4'],
      'TY': ['5', '6'],
      'BE': ['7', '8'],
    };
    onYearChanged(String? value) {
      //dont change second dropdown if 1st item didnt change
      if (value != selectedyear) selectedsem = null;
      setState(() {
        selectedyear = value;
      });
    }

    final rec = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
                          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child: TextFormField(
                            controller: subjectNamecontroller,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            // initialValue: facultyDetail[key].toString(),
                            decoration: InputDecoration(
                              // focusColor: Colors.black,
                              errorStyle: const TextStyle(color: Colors.white),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Subject',
                            ),
                            validator: (key) {
                              if (key == null || key.isEmpty) {
                                return "Add name";
                              }
                              return null;
                            },
                            onChanged: (key) {
                              // facultyDetail[key] = double.parse(value);

                              // todo
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
                                //underline: Container(),
                                isExpanded: true,
                                value: selectedyear,
                                items: dataset.keys.map((e) {
                                  return DropdownMenuItem<String?>(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                                onChanged: onYearChanged,
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
                                  //underline: Container(),
                                  value: selectedsem,
                                  items: (dataset[selectedyear] ?? []).map((e) {
                                    return DropdownMenuItem<String?>(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedsem = val!;
                                    });
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancel", style: TextStyle(color: Colors.indigo[300]))),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                    onPressed: () {
                      // todo
                      if (rec.currentState!.validate()) {
                        b[index]['Subject'] = {
                          subjectNamecontroller.text.toString(): {
                            "Branch": batchcontroller.text.toString(),
                            "Year": selectedyear.toString()
                          }
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
                          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child: TextFormField(
                            controller: firstcontroller,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            // initialValue: marks[key].toString(),
                            decoration: InputDecoration(
                              // focusColor: Colors.black,
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
                                return "Add first name";
                              }
                              return null;
                            },
                            onChanged: (key) {
                              // marks[key] = double.parse(value);

                              // todo
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child: TextFormField(
                            controller: middlecontroller,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,

                            // initialValue: marks[key].toString(),
                            decoration: InputDecoration(
                              // focusColor: Colors.black,
                              errorStyle: const TextStyle(color: Colors.white),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Middle Name',
                            ),
                            validator: (key) {
                              // if (key == null || key.isEmpty) {
                              //   return "Add roll";
                              // }
                              return null;
                            },
                            onChanged: (key) {
                              // marks[key] = double.parse(value);

                              // todo
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child: TextFormField(
                            controller: lastcontroller,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            // initialValue: marks[key].toString(),
                            decoration: InputDecoration(
                              // focusColor: Colors.black,
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
                                return "Add Last Name";
                              }
                              return null;
                            },
                            onChanged: (key) {
                              // marks[key] = double.parse(value);

                              // todo
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
                            // initialValue: marks[key].toString(),
                            decoration: InputDecoration(
                              // focusColor: Colors.black,
                              errorStyle: const TextStyle(color: Colors.white),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
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
                            onChanged: (key) {
                              // marks[key] = double.parse(value);

                              // todo
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child: TextFormField(
                            controller: mobilecontroller,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            // initialValue: marks[key].toString(),
                            decoration: InputDecoration(
                              // focusColor: Colors.black,
                              errorStyle: const TextStyle(color: Colors.white),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Mobile No.',
                            ),
                            validator: (key) {
                              // if (key == null || key.isEmpty) {
                              //   return "Add roll";
                              // }
                              return null;
                            },
                            onChanged: (key) {
                              // marks[key] = double.parse(value);

                              // todo
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
                      // todo
                      if (rec.currentState!.validate()) {
                        b.add({
                          "Name": {
                            "First": firstcontroller.text.toString(),
                            "Middle": middlecontroller.text.toString(),
                            "Last": lastcontroller.text.toString()
                          },
                          "Email": emailcontroller.text.toString(),
                          "Mobile": mobilecontroller.text.toString()
                        });

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

// void addForStudents(CollectionReference reference, name) async {
//   print(facultyDetail);
//
//   reference.doc("Roll_No").get().then((docsnap) {
//     (docsnap.data()! as Map<String, dynamic>).forEach((roll, ref) {
//       facultyDetail.containsKey(int.parse(roll))
//           ? ref.collection("Result").doc(selectedsub).set({
//               namecontroller.text: {"mark": facultyDetail[int.parse(roll)], "total": total, 'time': DateTime.now()},
//             }, SetOptions(merge: true))
//           : null;
//     });
//   });
// }
}
