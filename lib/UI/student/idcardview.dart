import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class viewID extends StatefulWidget {
  const viewID({Key? key}) : super(key: key);

  @override
  _viewIDState createState() => _viewIDState();
}

class _viewIDState extends State<viewID> {
  String? id;
  Future<void> _getprofilepicUrl() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        id = value.data()!['idcard'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getprofilepicUrl();
  }

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return Center(child: CircularProgressIndicator());
    } else
      return Container(child: Image.network(id!));
  }
}
