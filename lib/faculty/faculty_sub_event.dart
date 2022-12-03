import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FacultySubEvent extends StatefulWidget {
  FacultySubEvent({Key? key,required this.info}) : super(key: key);
  Map<String,dynamic> info = {};

  @override
  State<FacultySubEvent> createState() => _FacultySubEventState();
}

class _FacultySubEventState extends State<FacultySubEvent> {
  final maxLines = 5;
  final formkey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  String date = 'Select Date and Time of Event';

  File? file;
  String? url;
  Future selectFiles() async{
    final result = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if(result == null) return;
    final path = result.path;
    setState(() => file = File(path));
  }
  Future uploadFile() async {
    if(file == null) return;
    final destination = 'Events/${widget.info['Email']}/$date';
    final ref = FirebaseStorage.instance.ref(destination);
    await ref.putFile(file!);
    url = await ref.getDownloadURL();
  }

  void timePicker() async {
    TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
    DateTime date = DateUtils.dateOnly(DateTime.now());
    print(time);
    final DateTime? selecteddate = await showDatePicker(
        context: context,
        initialDate: date,
        lastDate: DateTime(2030),
        firstDate: DateTime(2010));
    final TimeOfDay? selectedtime =
    await showTimePicker(context: context, initialTime: time);
    if (selecteddate != null && selectedtime != null) {
      time = selectedtime;
      date = selecteddate;
      this.date = "${DateFormat('dd-MM-yyyy').format(date)}-${DateFormat('HH-mm').format(DateFormat('H:mm a').parse(time.format(context)))}";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Events',style: TextStyle(fontSize: 30,fontFamily: 'Narrow'),),
        backgroundColor: Colors.indigo[300],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 40,right: 40,bottom: 50),
                  child: TextFormField(
                    controller: title,
                    validator: (name) {
                      if(name == null || name.isEmpty){
                        return 'Enter the Title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: 'Title',
                    ),
                  ),
                ),
                Container(
                  height: maxLines * 40,
                  padding: const EdgeInsets.only(left: 40,right: 40),
                  child: TextFormField(
                    maxLines: maxLines,
                    controller: description,
                    validator: (name) {
                      if(name == null || name.isEmpty){
                        return 'Enter the Description';
                      }
                      return null;
                    },
                    decoration:  const InputDecoration(
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      labelText: 'Description',
                  ),
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    textStyle:
                    const TextStyle(fontFamily: 'MiliBold', fontSize: 18),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 15, right: 15),
                  ),
                  onPressed: (){timePicker();
                  },
                  child: Text(date
                      == 'Select Date and Time of Event'? date
                      : DateFormat('dd/MM/yyyy HH:mm')
                      .format(DateFormat('dd-MM-yyyy-HH-mm').parse(date))),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15,top: 40),
                  child: Text("Upload Image",style: TextStyle(fontFamily: 'MuliBold',fontSize: 20),),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: const Icon(Icons.add),
                    onPressed: () async {
                    await selectFiles();
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle:
                      const TextStyle(fontFamily: 'MuliBold', fontSize: 22),
                      onPrimary: Colors.black,
                      primary: Colors.white,
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, left: 15, right: 15),
                    ),
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        await uploadFile();
                        await FirebaseFirestore.instance.collection("Events").doc("$date").set({'Title':title.text,'Description':description.text,'Date':date,'urlEvent':url});
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
