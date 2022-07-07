import 'package:college_gate/panel/aboutus.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/main.dart';
import 'package:college_gate/panel/faculty/facultyList.dart';
import 'package:college_gate/panel/student/notices.dart';
import 'package:college_gate/panel/student/profile.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        iconSize: 24.sp,
        selectedIconTheme: IconThemeData(color: Color(0Xff15609c), size: 29.sp),
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

  void initState() {
    super.initState();
  }

  sendMail(String? name, String? date, String? phonenumber,
      String? hostelnumber, String? room) async {
    final Email email = Email(
      body:
          "<p>Respected Sir/Ma'am,<p> <p>This is to inform you that I, $name residing in $hostelnumber, room number $room will be be out of the hostel premises from $date for next few days, with my parents' consent.<p><b> For any other details please contact me at Mob: +91$phonenumber.<b><p> Sincerely.<p>",
      subject: 'Permission to go Home($date)',
      recipients: ["warden.girls@iiitl.ac.in", "warden.boys@iiitl.ac.in"],
      isHTML: true,
    );
    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    // var _formKey;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56.h,
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutUs()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 22.sp,
                )),
          )
        ],
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
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 13.h),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection('studentUser')
                        .doc((FirebaseAuth.instance.currentUser)!.email)
                        .get()
                        .then((value) {
                      String? exitapproved =
                          value.data()!['exitisapproved']?.toString();
                      if (exitapproved == "ExitApproved") {
                        flutterToast("Exit request is already approved");
                      } else if (exitapproved == "ExitPending")
                        flutterToast("Exit request is already sent");
                      else
                        showpurpose(context);
                    });
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 138.h,
                          child: Ink.image(
                            image: AssetImage("assets/exit.png"),
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
                                "Campus Exit Form",
                                style: TextStyle(
                                    fontSize: 16.sp, color: Color(0Xff15609c)),
                              ),
                              IconButton(
                                  alignment: Alignment.centerRight,
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('studentUser')
                                        .doc(
                                            (FirebaseAuth.instance.currentUser)!
                                                .email)
                                        .get()
                                        .then((value) {
                                      String? exitapproved = value
                                          .data()!['exitisapproved']
                                          ?.toString();
                                      if (exitapproved == "ExitApproved") {
                                        flutterToast(
                                            "Exit request is already approved");
                                      } else if (exitapproved == "ExitPending")
                                        flutterToast(
                                            "Exit request is already sent");
                                      else
                                        showpurpose(context);
                                    });
                                  },
                                  icon: Icon(Icons.chevron_right,
                                      size: 23.sp, color: Color(0Xff15609c)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection('studentUser')
                        .doc((FirebaseAuth.instance.currentUser)!.email)
                        .get()
                        .then((value) {
                      String? entryapproved =
                          value.data()!['entryisapproved']?.toString();
                      if (entryapproved == "EntryApproved") {
                        flutterToast(
                            "Cannot send entry request before exit is made.");
                      } else if (entryapproved == "EntryPending")
                        flutterToast("Entry request is already sent");
                      else
                        showentry(context);
                    });
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(children: [
                      SizedBox(
                        height: 138.h,
                        child: Ink.image(
                          image: AssetImage("assets/entry.png"),
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
                                  "Campus Entry Form",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0Xff15609c)),
                                ),
                                IconButton(
                                    alignment: Alignment.centerRight,
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('studentUser')
                                          .doc((FirebaseAuth
                                                  .instance.currentUser)!
                                              .email)
                                          .get()
                                          .then((value) {
                                        String? entryapproved = value
                                            .data()!['entryisapproved']
                                            ?.toString();
                                        if (entryapproved == "EntryApproved") {
                                          flutterToast(
                                              "Cannot send entry request before exit is made.");
                                        } else if (entryapproved ==
                                            "EntryPending")
                                          flutterToast(
                                              "Entry request is already sent");
                                        else
                                          showentry(context);
                                      });
                                    },
                                    icon: Icon(Icons.chevron_right,
                                        size: 23.sp, color: Color(0Xff15609c))),
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
                    elevation: 2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 138.h,
                          child: Ink.image(
                            image: AssetImage("assets/appointmentFaculty.png"),
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
                                "Book Appointment",
                                style: TextStyle(
                                    fontSize: 16.sp, color: Color(0Xff15609c)),
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
                                    size: 23.sp,
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
          return AlertDialog(
            //contentPadding: EdgeInsets.zero,
            title: Text(
              "Entry Request",
              style: TextStyle(fontSize: 18.sp, color: Color(0Xff15609c)),
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
                              fontSize: 14.sp, color: Colors.red[700]))),
                  SizedBox(
                    width: 15.w,
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
                          fontSize: 14.sp,
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
          return AlertDialog(
            title: Text(
              "Select Purpose",
              style: TextStyle(fontSize: 18.sp, color: Color(0Xff15609c)),
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
                              fontSize: 14.sp, color: Colors.red[700]))),
                  SizedBox(
                    width: 15.w,
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

                          if (_purpose == "Home") {
                            String? name;
                            String? phone;
                            String? hostelnumber;
                            String? roomno;

                            FirebaseFirestore.instance
                                .collection('studentUser')
                                .doc((FirebaseAuth.instance.currentUser!).email)
                                .get()
                                .then((value) {
                              setState(() {
                                name = value.data()!['name'].toString();
                                phone = value.data()!['phone'].toString();
                                hostelnumber =
                                    value.data()!['hostelno'].toString();
                                roomno = value.data()!['room'].toString();

                                sendMail(
                                        name!,
                                        "${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                                        phone,
                                        hostelnumber,
                                        roomno)
                                    .whenComplete(() {
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Warden Notified')));
                                });
                              });
                            });
                          }
                          ;
                          flutterToast("Exit Form Submitted");

                          Navigator.of(context).pop();
                        } else {
                          print("Not validated");
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 14.sp,
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
        fontSize: 14.sp,
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
