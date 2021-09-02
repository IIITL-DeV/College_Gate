import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addStudentUserInfoToDB(
      String userid, Map<String, dynamic> studentUserInfoMap) async {
    FirebaseFirestore.instance
        .collection("studentUser")
        .doc(userid)
        .set(studentUserInfoMap);
  }
}
