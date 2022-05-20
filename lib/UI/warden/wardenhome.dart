import 'package:college_gate/UI/sign_in.dart';
import 'package:college_gate/UI/warden/w_exitrequest.dart';
import 'package:college_gate/UI/warden/w_student_home_register.dart';
import 'package:college_gate/UI/warden/wardenlog.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';

class wardenHome extends StatefulWidget {
  const wardenHome({Key? key}) : super(key: key);

  @override
  _wardenHomeState createState() => _wardenHomeState();
}

class _wardenHomeState extends State<wardenHome> {
  int _currentIndex = 1;
  final List<Widget> _pages = <Widget>[
    w_log(),
    wardenHomeScreen(),
    wRequestHome(),
  ];

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightMobile = MediaQuery.of(context).size.height;

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
          title: Text("College Gate",style: TextStyle(fontSize: heightMobile * 0.025)),
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

  static w_exitrequests() {}
}

class wardenHomeScreen extends StatefulWidget {
  const wardenHomeScreen({Key? key}) : super(key: key);

  @override
  _wardenHomeScreenState createState() => _wardenHomeScreenState();
}

class _wardenHomeScreenState extends State<wardenHomeScreen> {
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              w_studentRegister()));
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
                              Text("Campus Entry Form",style: TextStyle(fontSize: heightMobile * 0.021,color: Color(0Xff232F77)),),
                              IconButton(
                                  alignment: Alignment.centerRight,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                w_studentRegister()));
                                  },
                                  icon: Icon(Icons.chevron_right,size: heightMobile * 0.03,color: Color(0Xff232F77))),
                            ])),
                  ]),
                ),
              ),
            ],
          ),
        ));
  }
}
