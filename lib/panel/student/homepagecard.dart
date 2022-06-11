import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/main.dart';
import 'package:college_gate/panel/faculty/facultyList.dart';
import 'package:college_gate/panel/gaurd/log.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/panel/student/notices.dart';
import 'package:college_gate/panel/student/profile.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class studentHome extends StatefulWidget {
  const studentHome({Key? key}) : super(key: key);

  @override
  _studentHomeState createState() => _studentHomeState();
}

class _studentHomeState extends State<studentHome> {
  int _currentIndex = 1;
  final List<Widget> _pages = <Widget>[
    Profile(),
    studentHomeScreen(),
    notices(),
  ];

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: heightMobile * 0.038,
        selectedIconTheme:
            IconThemeData(color: Color(0Xff15609c), size: heightMobile * 0.042),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // this will be set when a new tab is tapped
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notification',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTapTapped,
      ),
      body: Container(
        child: _pages.elementAt(_currentIndex),
      ),
    );
  }
}

class studentHomeScreen extends StatefulWidget {
  const studentHomeScreen({Key? key}) : super(key: key);

  @override
  _studentHomeScreenState createState() => _studentHomeScreenState();
}

class _studentHomeScreenState extends State<studentHomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _purpose = "Outing";
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    // var _formKey;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: heightMobile * 0.028,
                child: Image.asset("assets/cg_white.png")),
            SizedBox(
              width: 10,
            ),
            Text("College Gate",
                style: TextStyle(fontSize: heightMobile * 0.028)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
            height: heightMobile,
            width: widthMobile,
            padding: EdgeInsets.all(heightMobile * 0.02),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showpurpose(context);
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        SizedBox(
                          height: heightMobile * 0.169,
                          child: Ink.image(
                            image: AssetImage("assets/exit.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              heightMobile * 0.02,
                              heightMobile * 0.01,
                              heightMobile * 0.015,
                              heightMobile * 0.01),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Campus Exit Form",
                                style: TextStyle(
                                    fontSize: heightMobile * 0.021,
                                    color: Color(0Xff15609c)),
                              ),
                              IconButton(
                                  alignment: Alignment.centerRight,
                                  onPressed: () {
                                    showpurpose(context);
                                  },
                                  icon: Icon(Icons.chevron_right,
                                      size: heightMobile * 0.03,
                                      color: Color(0Xff15609c)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showentry(context);
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(children: [
                      SizedBox(
                        height: heightMobile * 0.169,
                        child: Ink.image(
                          image: AssetImage("assets/entry.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              heightMobile * 0.02,
                              heightMobile * 0.01,
                              heightMobile * 0.015,
                              heightMobile * 0.01),
                          alignment: Alignment.centerLeft,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Campus Entry Form",
                                  style: TextStyle(
                                      fontSize: heightMobile * 0.021,
                                      color: Color(0Xff15609c)),
                                ),
                                IconButton(
                                    alignment: Alignment.centerRight,
                                    onPressed: () {
                                      showentry(context);
                                    },
                                    icon: Icon(Icons.chevron_right,
                                        size: heightMobile * 0.03,
                                        color: Color(0Xff15609c))),
                              ])),
                    ]),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FacultyList(
                                  isStudent: true,
                                )));
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        SizedBox(
                          height: heightMobile * 0.169,
                          child: Ink.image(
                            image: AssetImage("assets/facultyAppointment.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              heightMobile * 0.02,
                              heightMobile * 0.01,
                              heightMobile * 0.015,
                              heightMobile * 0.01),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Book Appointment",
                                style: TextStyle(
                                    fontSize: heightMobile * 0.021,
                                    color: Color(0Xff15609c)),
                              ),
                              //SizedBox(width: widthMobile * 0.1,),
                              IconButton(
                                  alignment: Alignment.centerRight,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FacultyList(
                                                  isStudent: true,
                                                )));
                                  },
                                  icon: Icon(
                                    Icons.chevron_right,
                                    size: heightMobile * 0.03,
                                    color: Color(0Xff15609c),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  showentry(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double widthMobile = MediaQuery.of(context).size.width;
          double heightMobile = MediaQuery.of(context).size.height;
          return AlertDialog(
            title: Text(
              "Entry Request",
              style: TextStyle(
                  fontSize: heightMobile * 0.027, color: Color(0Xff15609c)),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.03,
                  // ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Navigator.of(context).pop();
                      },
                      child: Text("Cancel",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              color: Colors.red[700]))),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  TextButton(
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        FirebaseFirestore.instance
                            .collection('studentUser')
                            .doc((FirebaseAuth.instance.currentUser!).email)
                            .update({
                          'entryisapproved': "EntryPending",
                        });

                        flutterToast("Entry Form Submitted");
                        // Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: Color(0Xff19B38D),
                        ),
                      )),
                ],
              )
            ],
          );
        });
  }

  showpurpose(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double widthMobile = MediaQuery.of(context).size.width;
          double heightMobile = MediaQuery.of(context).size.height;
          return AlertDialog(
            title: Text(
              "Select Purpose",
              style: TextStyle(
                  fontSize: heightMobile * 0.027, color: Color(0Xff15609c)),
            ),
            content: Form(
              key: _formKey,
              child: Container(
                child: purpose(),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Navigator.of(context).pop();
                      },
                      child: Text("Cancel",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              color: Colors.red[700]))),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FirebaseFirestore.instance
                              .collection('studentUser')
                              .doc((FirebaseAuth.instance.currentUser!).email)
                              .update({
                            'exitisapproved': "ExitPending",
                            'purpose': _purpose,
                          });
                        } else {
                          print("Not validated");
                        }
                        // reschedulesendMail(
                        //   email,
                        //   _dateController.text,
                        //   _timeController.text,
                        // ).whenComplete(() {
                        //   setState(() {});
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(content: Text('Guest Notified')));
                        // });
                        flutterToast("Exit Form Submitted");
                        // Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: Color(0Xff19B38D),
                        ),
                      )),
                ],
              )
            ],
          );
        });
  }

  Widget purpose() {
    return DropdownButtonFormField<String>(
      value: _purpose,
      hint: Text(
        'Purpose',
      ),
      style: TextStyle(
        color: Colors.black,
        // fontSize: heightMobile * 0.02,
      ),
      onChanged: (newValue) => setState(() => _purpose = newValue),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Select purpose";
        } else {
          _purpose = value;
          return null;
        }
      },
      items: ['Outing', 'Home'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
