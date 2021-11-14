import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/UI/student/noNotices.dart';
import 'package:college_gate/UI/student/readytogo.dart';
import 'package:college_gate/UI/student/welcome.back.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class notices extends StatefulWidget {
  const notices({Key? key}) : super(key: key);

  @override
  _noticesState createState() => _noticesState();
}

class _noticesState extends State<notices> {
  String? _exitstatus, _entrystatus;
  Future<void> _getexitstatus() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _exitstatus = value.data()!['exitisapproved'].toString();
      });
    });
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _entrystatus = value.data()!['entryisapproved'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getexitstatus();
  }

  @override
  Widget build(BuildContext context) {
    // if (_exitstatus == false) return requestPending();
    if (_exitstatus == true) return ReadytoGo();
    // if (_entrystatus == false) return requestPending();
    if (_entrystatus == true) return welcomeback();
    return noNotices();
  }
}
