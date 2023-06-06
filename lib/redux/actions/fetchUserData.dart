import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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

  final firestoreinst = FirebaseFirestore.instance;

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

  Future<bool?> getUserType(email) async {
    return await firestoreinst.collection('Student_Detail').where('Email', isEqualTo: "$email").limit(1).count().get().then((value) {
      if (value.count == 1) {
        return true;
      } else {
        return firestoreinst.collection('Faculty_Detail').where('Email', isEqualTo: "$email").limit(1).count().get().then((value) {
          if (value.count == 1) {
            return false;
          } else {
            return null;
          }
        });
      }
    });
  }

  Future<void> fetchStudentData(String? email) async {
    try {
      await firestoreinst.collection('Student_Detail').where('Email', isEqualTo: "$email").limit(1).get().then((value) async {
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
      });
      // notifyListeners();
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> fetchFacultyData(String? email) async {
    try {
      CollectionReference<Map<String, dynamic>> query = firestoreinst.collection('Faculty_Detail');
      await query.where('Email', isEqualTo: "$email").limit(1).get().then((value) async {
        query.doc(value.docs[0].id).set({"Token": await FirebaseMessaging.instance.getToken()}, SetOptions(merge: true));
        store.dispatch(FetchData(
            name: value.docs[0]["Name"],
            branch: value.docs[0]['Branch'],
            email: value.docs[0]['Email'],
            mobile: value.docs[0]['Mobile'],
            isStudent: false,
            imgUrl: value.docs[0].data().containsKey("imgUrl") ? value.docs[0]["imgUrl"] : null,
            subject: value.docs[0]["Subjects"]));
      });
    } on FirebaseException {
      rethrow;
    }
  }
}
