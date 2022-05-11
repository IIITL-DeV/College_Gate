import 'package:college_gate/UI/gaurd/log.dart';
import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/UI/student/entry.dart';
import 'package:college_gate/UI/student/exit_screen.dart';
import 'package:college_gate/UI/student/notices.dart';
import 'package:college_gate/UI/student/profile.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedIconTheme: IconThemeData(color: Color(0Xff15609c), size: 40),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // this will be set when a new tab is tapped
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
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

class studentHomeScreen extends StatefulWidget {
  const studentHomeScreen({Key? key}) : super(key: key);

  @override
  _studentHomeScreenState createState() => _studentHomeScreenState();
}

class _studentHomeScreenState extends State<studentHomeScreen> {
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
                        Text("Campus Exit Form"),
                        IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExitForm()));
                            },
                            icon: const Icon(Icons.chevron_right))
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                      Text("Campus Entry Form"),
                      IconButton(
                          alignment: Alignment.centerRight,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EntryForm()));
                          },
                          icon: const Icon(Icons.chevron_right)),
                    ])),
              ]),
            ),
          ],
        ));
  }
}
