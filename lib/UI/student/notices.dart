import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/student/no_notices.dart';
import 'package:college_gate/UI/student/readytogo.dart';
import 'package:college_gate/UI/student/requestpending.dart';
import 'package:college_gate/UI/student/welcomeback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class notices extends StatefulWidget {
  @override
  _noticesState createState() => _noticesState();
}

class _noticesState extends State<notices> {
  bool exitstatus = false;
  bool entrystatus = false;

  var stream;
  @override
  void initState() {
    super.initState();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  String? _exitisapproved, _entryisapproved;

  Future<void> _getUserDetails() async {
    FirebaseFirestore.instance
        .collection('studentGuest')
        .doc(await (FirebaseAuth.instance.currentUser)!.email)
        .collection("guestUser")
        .doc()
        .get()
        .then((value) {
      setState(() {
        _exitisapproved = value.data()!['exitisapproved'].toString();
        _entryisapproved = value.data()!['entryisapproved'].toString();
      });
    });
  }

  @override
  build(BuildContext context) {
    if ((_exitisapproved == false) || (_entryisapproved == false))
      return requestpending();

    if (_entryisapproved == true) {
      FirebaseFirestore.instance
          .collection('studentUser')
          .doc((FirebaseAuth.instance.currentUser!).email)
          .update(
        {'exitisapproved': null},
      );
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => welcomeback()));
      return welcomeback();
    }

    if (_exitisapproved == true) {
      FirebaseFirestore.instance
          .collection('studentUser')
          .doc((FirebaseAuth.instance.currentUser!).email)
          .update(
        {'entryisapproved': null},
      );
      return ReadytoGo();
    }
    return noNotices();
  }
}
