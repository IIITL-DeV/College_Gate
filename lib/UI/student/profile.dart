import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/student/idcardview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../warden/viewimage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _idcard, _username, _enrollmentNo, _email, _roomno, _phoneno;
  Future<void> getdetails() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).email)
        .get()
        .then((value) {
      setState(() {
        _idcard = value.data()!['idcard'].toString();
        _email = value.data()!['email'].toString();
        _username = value.data()!['name'].toString();
        _enrollmentNo = value.data()!['enrollment'].toString();
        _phoneno = value.data()!['phone'].toString();
        _roomno = value.data()!['room'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getdetails();
  }

  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    if (_username == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          // height: MediaQuery.of(context).size.height,
          width: widthMobile,
          padding: EdgeInsets.symmetric(
              vertical: heightMobile * 0.04, horizontal: widthMobile * 0.08),
          child: Form(
              key: _formKey,
              child: Center(
                  child: Column(
                children: [
                  SizedBox(height: heightMobile * 0.06),
                  SizedBox(
                    height: heightMobile * 0.15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1500),
                      child: GestureDetector(
                          child: Hero(
                            tag: _idcard!,
                            child: Image.network(_idcard!, fit: BoxFit.contain),
                          ),
                          onTap: () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return viewImage(_idcard!);
                            }));
                          }),
                    ),
                  ),
                  SizedBox(height: heightMobile * 0.015),
                  Text(
                    _username!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: heightMobile * 0.024,
                    ),
                  ),
                  SizedBox(height: heightMobile * 0.009),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Enrollnment Number'),
                    initialValue: _enrollmentNo,
                    style: TextStyle(
                      fontSize: heightMobile * 0.021,
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: heightMobile * 0.009),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    initialValue: _email,
                    style: TextStyle(
                      fontSize: heightMobile * 0.021,
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: heightMobile * 0.009),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    initialValue: _phoneno,
                    style: TextStyle(
                      fontSize: heightMobile * 0.021,
                    ),
                  ),
                  SizedBox(height: heightMobile * 0.009),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Room number'),
                    initialValue: _roomno,
                    style: TextStyle(
                      fontSize: heightMobile * 0.021,
                    ),
                  ),
                  SizedBox(height: heightMobile * 0.02),
                ],
              )))),
    ));
  }
}
