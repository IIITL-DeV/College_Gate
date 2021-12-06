import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/student/noNotices.dart';
import 'package:college_gate/UI/student/readytogo.dart';
import 'package:college_gate/UI/student/requestpending.dart';
import 'package:college_gate/UI/student/welcomeback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class notices extends StatefulWidget {
  @override
  _noticesState createState() => _noticesState();
}

class _noticesState extends State<notices> {
  bool exitstatus = false;
  bool entrystatus = false;

  @override
  void initState() {
    super.initState();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("studentUser")
            .where('userid', isEqualTo: auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: const CircularProgressIndicator());

          final DocumentSnapshot _card = snapshot.data!.docs[0];

          // if (_card['entryisapproved'] == null &&
          //     _card['exitisapproved'] == null) return noNotices();

          if ((_card['exitisapproved'] == false) ||
              (_card['entryisapproved'] == false)) return requestpending();

          if (_card['entryisapproved'] == true) {
            FirebaseFirestore.instance
                .collection('studentUser')
                .doc((FirebaseAuth.instance.currentUser!).uid)
                .update(
              {'exitisapproved': null},
            );
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => welcomeback()));
            return welcomeback();
          }

          if (_card['exitisapproved'] == true) {
            FirebaseFirestore.instance
                .collection('studentUser')
                .doc((FirebaseAuth.instance.currentUser!).uid)
                .update(
              {'entryisapproved': null},
            );
            return ReadytoGo();
          }
          return noNotices();
        });
  }
}
