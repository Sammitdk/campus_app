import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../reducer.dart';
import "./../store.dart";

class FetchData extends ChangeNotifier {
  final dynamic email;
  final dynamic roll_No;
  final dynamic prn;
  final dynamic address;
  final dynamic branch;
  final dynamic mobile;
  final dynamic name;
  final dynamic sem;
  final dynamic year;
  final dynamic dob;
  final dynamic isStudent;
  dynamic imgUrl;
  dynamic subject;

  FetchData(
      {this.imgUrl,
      this.isStudent,
      this.address,
      this.branch,
      this.mobile,
      this.name,
      this.sem,
      this.year,
      this.email,
      this.roll_No,
      this.prn,
      this.dob,
      this.subject});
  Future<void> fetchUserData(String? email) async {
    try {
      final firestoreinst = FirebaseFirestore.instance;

      await firestoreinst.collection('Student_Detail').where('Email', isEqualTo: "$email").get().then((value) async {
        if (value.docs.isNotEmpty) {
          await firestoreinst
              .doc("Student_Detail/${value.docs[0]['PRN']}")
              .set({"Token": "${await FirebaseMessaging.instance.getToken()}"}, SetOptions(merge: true));
          store.dispatch(FetchData(
              email: email,
              prn: value.docs[0]['PRN'],
              roll_No: value.docs[0]['Roll_No'],
              address: value.docs[0]['Address'],
              sem: value.docs[0]['Sem'],
              mobile: value.docs[0]['Mobile'][0],
              year: value.docs[0]['Year'],
              dob: value.docs[0]['DOB'],
              name: value.docs[0]['Name'],
              isStudent: true,
              branch: value.docs[0]["Branch"],
              imgUrl: value.docs[0].data().containsKey("imgUrl") ? value.docs[0]["imgUrl"] : null));
        } else {
          await firestoreinst.doc('Faculty_Detail/$email').get().then((value) async {
            firestoreinst
                .doc("Faculty_Detail/$email")
                .set({"Token": await FirebaseMessaging.instance.getToken()}, SetOptions(merge: true));
            final data = value.data() as Map<String, dynamic>;
            store.dispatch(FetchData(
                name: data["Name"],
                email: data['Email'],
                roll_No: data['Roll_No'],
                mobile: data['Mobile'],
                isStudent: false,
                imgUrl: data.containsKey("imgUrl") ? data["imgUrl"] : null,
                branch: data['Branch'],
                subject: data["Subjects"]));
          });
        }
      });
      notifyListeners();
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
}
