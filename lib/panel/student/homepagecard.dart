import 'dart:ui';

import 'package:college_gate/panel/faculty/facultyList.dart';
import 'package:college_gate/panel/gaurd/log.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/panel/student/entry.dart';
import 'package:college_gate/panel/student/exit_screen.dart';
import 'package:college_gate/panel/student/notices.dart';
import 'package:college_gate/panel/student/profile.dart';
import 'package:college_gate/services/auth.dart';
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
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
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
          // actions: [
          //   InkWell(
          //     onTap: () {
          //       AuthMethods().logout().then((s) {
          //         Navigator.pushReplacement(context,
          //             MaterialPageRoute(builder: (context) => SignIn()));
          //       });
          //     },
          //     child: Container(
          //         padding:
          //             EdgeInsets.symmetric(horizontal: heightMobile * 0.024),
          //         child: Icon(
          //           Icons.exit_to_app,
          //           color: Colors.deepPurple[50],
          //           size: heightMobile * 0.027,
          //         )),
          //   )
          // ]),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ExitForm()));
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ExitForm()));
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EntryForm()));
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EntryForm()));
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FacultyList()));
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
                                            builder: (context) =>
                                                FacultyList()));
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
}
