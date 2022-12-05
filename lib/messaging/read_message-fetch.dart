import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> getMessageReads(dynamic data, dynamic groupName) async {
  int count = 0;
  await FirebaseFirestore.instance
      .collection("GroupMessages/$groupName/Messages")
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      if (doc['users'].contains(data.email) == false) {
        count += 1;
      }
    }
  }).then((value) {
    return count;
  });
  return count;
}

void readAll(dynamic data, String groupName) {
  FirebaseFirestore.instance
      .collection("GroupMessages/$groupName/Messages")
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      if (doc['users'].contains(data.email) == false) {
        FirebaseFirestore.instance
            .collection("GroupMessages/$groupName/Messages")
            .doc(doc.id)
            .update({
          'users': FieldValue.arrayUnion([data.email])
        });
      }
    }
  });
}
