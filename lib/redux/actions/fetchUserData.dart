import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../reducer.dart';
import "./../store.dart";

class FetchData {
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
  final dynamic imgUrl;
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
      this.dob});
}

Future<ThunkAction<AppState>> fetchUserData(String? email) async {
  final DocumentReference studentRef =
      FirebaseFirestore.instance.doc('Email/$email');
  await studentRef.get().then((value) async {
    if (value.exists) {
      final data = value.data() as Map<String, dynamic>;
      await data["PRN"].get().then((value) async {
        final data = value.data() as Map<String, dynamic>;
        store.dispatch(FetchData(
            email: studentRef.id,
            prn: data['PRN'],
            roll_No: data['Roll_No'],
            address: data['Address'],
            sem: data['Sem'],
            mobile: data['Mobile'][0],
            year: data['Year'],
            dob: data['DOB'],
            name: data['Name'],
            isStudent: true,
            branch: data["Branch"],
            imgUrl: data['imgUrl']));
      });
    } else {
      final DocumentReference facultyRef = FirebaseFirestore.instance
          .doc('Faculty_Detail/sammitkhade77@gmail.com');
      await facultyRef.get().then((value) async {
        final data = value.data() as Map<String, dynamic>;
        store.dispatch(FetchData(
            email: studentRef.id,
            prn: data['PRN'],
            roll_No: data['Roll_No'],
            isStudent: false));
      });
    }
  });

  return (Store<AppState> store) async {};
}
