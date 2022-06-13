import 'dart:ui';
import 'dart:io';
import 'package:college_gate/panel/gaurd/deliveryEntry.dart';
import 'package:college_gate/panel/gaurd/studentRegister.dart';
import 'package:path_provider/path_provider.dart';
import 'package:college_gate/panel/gaurd/guestregister.dart';
import 'package:college_gate/panel/gaurd/log.dart';
import 'package:college_gate/panel/gaurd/exitrequest.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class gaurdHome extends StatefulWidget {
  const gaurdHome({Key? key}) : super(key: key);

  @override
  _gaurdHomeState createState() => _gaurdHomeState();
}

class _gaurdHomeState extends State<gaurdHome> {
  int _currentIndex = 1;
  final List<Widget> _pages = <Widget>[
    guardLog(),
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
        iconSize: 24.sp,
        selectedIconTheme: IconThemeData(color: Color(0Xff15609c), size: 29.sp),
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
        toolbarHeight: 56.h,
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 21.sp, child: Image.asset("assets/cg_white.png")),
            SizedBox(
              width: 12.w,
            ),
            Text("College Gate", style: TextStyle(fontSize: 21.sp)),
            //SizedBox(width: 50.w,),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().logout().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
                //padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 20.sp,
            )),
          ),
          SizedBox(
            width: 20.w,
          )
        ],
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
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Add your onPressed code here!
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DeliveryEntry()));
        },
        label: Text(
          'New Entry',
          style: TextStyle(fontSize: 13.sp),
        ),
        icon: Icon(
          Icons.add,
          size: 20.sp,
        ),
        backgroundColor: Color(0Xff15609c),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 13.h),
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
                  elevation: 2,
                  child: Column(children: [
                    SizedBox(
                      height: 145.h,
                      child: Ink.image(
                        image: AssetImage("assets/studentAppointment.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(15.w, 8.h, 5.w, 8.h),
                        alignment: Alignment.centerLeft,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Students",
                                style: TextStyle(
                                    fontSize: 16.sp, color: Color(0Xff232F77)),
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
                                      size: 23.sp, color: Color(0Xff232F77))),
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
                  elevation: 2,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 145.h,
                        child: Ink.image(
                          image: AssetImage("assets/facultyAppointment.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.w, 8.h, 5.w, 8.h),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Guests",
                              style: TextStyle(
                                  fontSize: 16.sp, color: Color(0Xff232F77)),
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
                                    size: 23.sp, color: Color(0Xff232F77)))
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
