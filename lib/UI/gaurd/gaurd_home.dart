import 'dart:ui';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:college_gate/UI/gaurd/guestregister.dart';
import 'package:college_gate/UI/gaurd/log.dart';
import 'package:college_gate/UI/gaurd/exitrequest.dart';
import 'package:college_gate/UI/gaurd/studentregister.dart';
import 'package:college_gate/UI/sign_in.dart';
import 'package:college_gate/UI/student/exit_screen.dart';
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
          title: Text(
            "College Gate",
            style: TextStyle(fontSize: heightMobile * 0.025),
          ),
          actions: [
            InkWell(
              onTap: () {
                AuthMethods().logout().then((s) async {
                  await _deleteCacheDir();
                  await _deleteAppDir();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                });
              },
              child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: heightMobile * 0.024),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.deepPurple[50],
                    size: heightMobile * 0.027,
                  )),
            )
          ]),
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
    return Container(
        height: heightMobile,
        width: widthMobile,
        padding: EdgeInsets.all(heightMobile * 0.02),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentRegister()));
                },
                child: Column(children: [
                  SizedBox(
                    height: heightMobile * 0.2,
                    child: Ink.image(
                      image: AssetImage("assets/entry.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(
                          heightMobile * 0.015,
                          heightMobile * 0.01,
                          heightMobile * 0.015,
                          heightMobile * 0.01),
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Text(
                          "Students",
                          style: TextStyle(fontSize: heightMobile * 0.019),
                        ),
                        IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StudentRegister()));
                            },
                            icon: Icon(
                              Icons.chevron_right,
                              size: heightMobile * 0.03,
                            )),
                      ])),
                ]),
              ),
            ),
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => guestRegister()));
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: heightMobile * 0.2,
                      child: Ink.image(
                        image: AssetImage("assets/exit.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          heightMobile * 0.015,
                          heightMobile * 0.01,
                          heightMobile * 0.015,
                          heightMobile * 0.01),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            "Guests",
                            style: TextStyle(fontSize: heightMobile * 0.019),
                          ),
                          IconButton(
                              alignment: Alignment.centerRight,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => guestRegister()));
                              },
                              icon: Icon(
                                Icons.chevron_right,
                                size: heightMobile * 0.03,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
