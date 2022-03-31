import 'package:college_gate/UI/gaurd/guestregister.dart';
import 'package:college_gate/UI/gaurd/log.dart';
import 'package:college_gate/UI/gaurd/exitrequest.dart';
import 'package:college_gate/UI/gaurd/studentRegister.dart';
import 'package:college_gate/UI/signIn.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedIconTheme: IconThemeData(color: Color(0Xff15609c), size: 40),
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
          title: Text("College Gate"),
          actions: [
            InkWell(
              onTap: () {
                AuthMethods().logout().then((s) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.deepPurple[50],
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
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.19,
                  child: Ink.image(
                    image: AssetImage("assets/entry.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(12.0),
                    alignment: Alignment.centerLeft,
                    child: Row(children: [
                      Text("Students"),
                      IconButton(
                          alignment: Alignment.centerRight,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => studentRegister()));
                          },
                          icon: const Icon(Icons.chevron_right)),
                    ])),
              ]),
            ),
            Card(
              elevation: 4,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.19,
                    child: Ink.image(
                      image: AssetImage("assets/exit.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text("Guests"),
                        IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => guestRegister()));
                            },
                            icon: const Icon(Icons.chevron_right))
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
