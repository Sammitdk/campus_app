import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> getMessageReads(dynamic data, dynamic gropName) async {
  int count = 0;
  await FirebaseFirestore.instance
      .collection("College/${data.branch}/MessageGroups/$gropName/Messages")
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
      .collection("College/${data.branch}/MessageGroups/$groupName/Messages")
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      if (doc['users'].contains(data.email) == false) {
        FirebaseFirestore.instance
            .collection(
                "College/${data.branch}/MessageGroups/$groupName/Messages")
            .doc(doc.id)
            .update({
          'users': FieldValue.arrayUnion([data.email])
        });
      }
    }
  });
}
