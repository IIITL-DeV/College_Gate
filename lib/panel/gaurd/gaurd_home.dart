import 'dart:ui';
import 'dart:io';
import 'package:college_gate/panel/gaurd/deliveryEntry.dart';
import 'package:college_gate/panel/gaurd/studentRegister.dart';
import 'package:path_provider/path_provider.dart';
import 'package:college_gate/panel/gaurd/guestregister.dart';
import 'package:college_gate/panel/gaurd/log.dart';
import 'package:college_gate/panel/gaurd/exitrequest.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/panel/student/exit_screen.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';

class gaurdHome extends StatefulWidget {
  const gaurdHome({Key? key}) : super(key: key);

  @override
  _gaurdHomeState createState() => _gaurdHomeState();
}

class _gaurdHomeState extends State<gaurdHome> {
  int _currentIndex = 1;
  final List<Widget> _pages = <Widget>[
    gaurdlog(),
    gaurdHomeScreen(),
    guardRequestHome(),
  ];

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _deleteCacheDir() async {
    Directory tempDir = await getTemporaryDirectory();

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
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
            icon: Icon(Icons.text_snippet_outlined),
            label: 'Alert',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Message',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTapTapped,
      ),
      appBar: AppBar(
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              height: heightMobile * 0.028,
              child: Image.asset("assets/cg_white.png")),
          SizedBox(
            width: 10,
          ),
          Text("College Gate",
              style: TextStyle(fontSize: heightMobile * 0.028)),
          InkWell(
            onTap: () {
              AuthMethods().logout().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: heightMobile * 0.024),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.deepPurple[50],
                  size: heightMobile * 0.027,
                )),
          ),
        ]),
      ),
      // AppBar(
      //     backgroundColor: Color(0Xff15609c),
      //     title: Text(
      //       "College Gate",
      //       style: TextStyle(fontSize: heightMobile * 0.025),
      //     ),
      //     actions: [
      //       InkWell(
      //         onTap: () {
      //           AuthMethods().logout().then((s) async {
      //             await _deleteCacheDir();
      //             await _deleteAppDir();
      //             Navigator.pushReplacement(context,
      //                 MaterialPageRoute(builder: (context) => SignIn()));
      //           });
      //         },
      //         child: Container(
      //             padding:
      //                 EdgeInsets.symmetric(horizontal: heightMobile * 0.024),
      //             child: Icon(
      //               Icons.exit_to_app,
      //               color: Colors.deepPurple[50],
      //               size: heightMobile * 0.027,
      //             )),
      //       )
      //     ]),
      body: Container(
        child: _pages.elementAt(_currentIndex),
      ),
    );
  }
}

class gaurdHomeScreen extends StatefulWidget {
  const gaurdHomeScreen({Key? key}) : super(key: key);

  @override
  _gaurdHomeScreenState createState() => _gaurdHomeScreenState();
}

class _gaurdHomeScreenState extends State<gaurdHomeScreen> {
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Add your onPressed code here!
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DeliveryEntry()));
        },
        label: Text(
          'New Entry',
          style: TextStyle(fontSize: heightMobile * 0.02),
        ),
        icon: Icon(
          Icons.add,
          size: heightMobile * 0.035,
        ),
        backgroundColor: Color(0Xff15609c),
      ),
      body: Container(
          height: heightMobile,
          width: widthMobile,
          padding: EdgeInsets.all(heightMobile * 0.02),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentRegister()));
                },
                child: Card(
                  elevation: 4,
                  child: Column(children: [
                    SizedBox(
                      height: heightMobile * 0.2,
                      child: Ink.image(
                        image: AssetImage("assets/studentAppointment.png"),
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
                                "Students",
                                style: TextStyle(
                                    fontSize: heightMobile * 0.021,
                                    color: Color(0Xff232F77)),
                              ),
                              IconButton(
                                  alignment: Alignment.centerRight,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StudentRegister()));
                                  },
                                  icon: Icon(Icons.chevron_right,
                                      size: heightMobile * 0.03,
                                      color: Color(0Xff232F77))),
                            ])),
                  ]),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => guestRegister()));
                },
                child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      SizedBox(
                        height: heightMobile * 0.2,
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
                              "Guests",
                              style: TextStyle(
                                  fontSize: heightMobile * 0.021,
                                  color: Color(0Xff232F77)),
                            ),
                            IconButton(
                                alignment: Alignment.centerRight,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              guestRegister()));
                                },
                                icon: Icon(Icons.chevron_right,
                                    size: heightMobile * 0.03,
                                    color: Color(0Xff232F77)))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
