import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  addStudentUserInfoToDB(
      String userid, Map<String, dynamic> studentUserInfoMap) async {
    FirebaseFirestore.instance
        .collection("studentUser")
        .doc(userid)
        .set(studentUserInfoMap);
  }

  Future<QuerySnapshot> getUserInfo() async {
    return await FirebaseFirestore.instance.collection("studentUser").get();
  }
}
