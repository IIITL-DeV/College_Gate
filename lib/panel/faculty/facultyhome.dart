import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'AppointmentRequest.dart';
import 'facultyProfile.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class FacultyHome extends StatefulWidget {
  const FacultyHome({Key? key}) : super(key: key);

  @override
  _FacultyHomeState createState() => _FacultyHomeState();
}

class _FacultyHomeState extends State<FacultyHome> {
  int _currentIndex = 1;
  final List<Widget> _pages = <Widget>[
    facultyProfile(),
    AppointmentList(),
    AppointmentRequest()
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
            icon: Icon(CupertinoIcons.calendar_today),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Request',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTapTapped,
      ),
      // appBar: AppBar(
      //     backgroundColor: Color(0Xff15609c),
      //     title: Text("College Gate",
      //         style: TextStyle(fontSize: heightMobile * 0.025)),
      //     actions: [
      //       InkWell(
      //         onTap: () {},
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

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  late String _hour, _minute, _time;

  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  reschedulesendMail(
    String guestemail,
    String date,
    String time,
  ) async {
    final Email email = Email(
      body:
          "I have to reschedule our appointment due to some unforeseen circumsatnces at $time, $date. ",
      subject: 'Appointment Rescheduled!',
      recipients: [guestemail],
      isHTML: true,
    );
    await FlutterEmailSender.send(email);
  }

  Future<Null> _selectDate(
      BuildContext context, String name, String email) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2021),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Color(0Xff19B38D), //Color(0Xff15609c)
            onSurface: Color(0Xff15609c),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
        _selectTime(context, name, email);
      });
  }

  Future<Null> _selectTime(
      BuildContext context, String name, String email) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Color(0Xff19B38D), //Color(0Xff15609c)
            onSurface: Color(0Xff15609c),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();

        appointmentReschedule(context, name, email);
      });
    //Navigator.of(context).pop();
  }

  Future<dynamic> appointmentReschedule(
      BuildContext context, String name, String email) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double widthMobile = MediaQuery.of(context).size.width;
          double heightMobile = MediaQuery.of(context).size.height;
          return AlertDialog(
            title: Text(
              "Reschedule",
              style: TextStyle(
                  fontSize: heightMobile * 0.027, color: Color(0Xff15609c)),
            ),
            content: Container(
              child: Text(
                'Reschedule Appointment with $name at ${_timeController.text} on ${_dateController.text}.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: heightMobile * 0.021,
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('facultyGuest')
                            .doc((FirebaseAuth.instance.currentUser!).email)
                            .collection("guestemail")
                            .doc(email)
                            .update({
                          'guestappointdate': _dateController.text,
                          'guestappointtime': _timeController.text,
                        });
                        reschedulesendMail(
                          email,
                          _dateController.text,
                          _timeController.text,
                        ).whenComplete(() {
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Guest Notified')));
                        });
                        flutterToast("Rescheduled Successfully");
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: Color(0Xff19B38D),
                        ),
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              color: Colors.red[700]))),
                ],
              )
            ],
          );
        });
  }

  var stream;
  void initState() {
    super.initState();
    // getfacultyDetails;
    stream = FirebaseFirestore.instance
        .collection("facultyGuest")
        .doc((FirebaseAuth.instance.currentUser!).email)
        .collection("guestemail")
        .where("appointisapproved", isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.195;
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
      body: StreamBuilder(
          stream: stream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              int value;
              value = snapshot.data!.docs.length;
              if (value == 0 || value == null) {
                print("issssss$value");
                return SizedBox(
                    width: widthMobile,
                    height: heightMobile,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: heightMobile * 0.13),
                        Image.asset(
                          'assets/nonotices.png',
                          //fit: BoxFit.fitWidth,
                          width: widthMobile * 0.8,
                          height: heightMobile * 0.4,
                          alignment: Alignment.center,
                        ),
                        Text("No Appointment",
                            style: TextStyle(
                              fontSize: heightMobile * 0.04,
                              fontWeight: FontWeight.w300,
                              color: Color(0Xff14619C),
                            )),
                      ],
                    ));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final chatItem = snapshot.data!.docs[index];
                  return Padding(
                    padding: EdgeInsets.all(heightMobile * 0.008),
                    child: Card(
                      elevation: 3.5,
                      child: SizedBox(
                        height: cardheight,
                        width: widthMobile * 0.9,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              title: Text(
                                "${chatItem["guestname"]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: cardheight * 0.13,
                                    fontWeight: FontWeight.bold),
                              ),
                              //Phone number and Time
                              subtitle: Container(
                                  child: Column(children: [
                                SizedBox(
                                  height: cardheight * 0.04,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_call,
                                      size: cardheight * 0.07,
                                    ),
                                    SizedBox(
                                      width: widthMobile * 0.02,
                                    ),
                                    Text(
                                      "${chatItem["guestphone"]}",
                                      style: TextStyle(
                                          fontSize: cardheight * 0.09),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: cardheight * 0.03,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_alarm,
                                      size: cardheight * 0.08,
                                    ),
                                    SizedBox(
                                      width: widthMobile * 0.02,
                                    ),
                                    Text(
                                      "${chatItem["guestappointtime"]} | ${chatItem["guestappointdate"]}",
                                      style: TextStyle(
                                        fontSize: cardheight * 0.08,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    ),
                                  ],
                                ),
                              ])),
                              //Id Image
                              //Room Number
                              trailing: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    //SizedBox(height: cardheight * 0.07),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 0.0, 08.0, 0.0),
                                      child: Text(
                                        "${chatItem["what"]}",
                                        style: TextStyle(
                                            fontSize: cardheight * 0.09,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // SizedBox(height: cardheight * 0.07),
                                    TextButton.icon(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                double widthMobile =
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width;
                                                double heightMobile =
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height;
                                                return AlertDialog(
                                                  title: Text(
                                                    "Description",
                                                    style: TextStyle(
                                                        fontSize: heightMobile *
                                                            0.027,
                                                        color:
                                                            Color(0Xff15609c)),
                                                  ),
                                                  content: Container(
                                                    child: Text(
                                                      '${chatItem["guestpurpose"]}',
                                                      //softWrap: true,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: heightMobile *
                                                            0.021,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(
                                          CupertinoIcons
                                              .arrowtriangle_down_circle_fill,
                                          size: cardheight * 0.11,
                                          color: Color(0Xff14619C),
                                        ),
                                        label: Text(
                                          "Description",
                                          style: TextStyle(
                                              fontSize: heightMobile * 0.016,
                                              color: Color(0Xff15609c)),
                                        ))
                                    // InkWell(
                                    //     onTap: () {
                                    //       dialogBox();
                                    //     },
                                    //     child: Text(
                                    //       "Description",
                                    //       style: TextStyle(
                                    //           fontSize: heightMobile * 0.016,
                                    //           color: Color(0Xff15609c)),
                                    //     )
                                    //     // Icon(
                                    //     //   CupertinoIcons.arrowtriangle_down_circle_fill,
                                    //     //   size: cardheight * 0.14 ,
                                    //     //   color: Color(0Xff14619C),
                                    //     // ),
                                    //     )
                                  ],
                                ),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(
                                  cardheight * 0.1,
                                  cardheight * 0.1,
                                  cardheight * 0.1,
                                  cardheight * 0.05),
                            ),
                            // SizedBox(
                            //   height: cardheight * 0.05,
                            // ),
                            //Accept, Decline button
                            Column(
                              children: [
                                Container(
                                  height: cardheight * 0.25,
                                  width: widthMobile * 0.88,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _selectDate(
                                          context,
                                          chatItem["guestname"].toString(),
                                          chatItem["guestemail"].toString());
                                    },
                                    child: Text(
                                      'Reschedule',
                                      style: TextStyle(
                                          fontSize: heightMobile * 0.022,
                                          color: Color(0Xff19B38D)),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: Color(0Xff19B38D), width: 2),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //
                                  //   },
                                  //   child: Text(
                                  //     "Reschedule",
                                  //     style: TextStyle(
                                  //       fontSize: cardheight * 0.1,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  //   style: ButtonStyle(
                                  //     side: MaterialStateProperty.all(value),
                                  //     backgroundColor:
                                  //     MaterialStateProperty.all<Color>(
                                  //         Color(0Xff19B38D)),
                                  //   ),
                                  // ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: cardheight * 0.1,
                            )
                          ],
                        ),
                      ),
                    ),
                  );

                  // return ListTile(
                  //   leading: Text(
                  //     chatItem["name"] ?? '',
                  //     style: TextStyle(
                  //         //fontWeight: FontWeight.bold,
                  //         fontSize: 20),
                  //   ),
                  //   subtitle: Column(
                  //     children: <Widget>[
                  //       ElevatedButton(
                  //           child: Text('Accept'),
                  //           onPressed: () {
                  //             FirebaseFirestore.instance
                  //                 .collection("studentUser")
                  //                 .doc(chatItem["userid"])
                  //                 .update({"exitisapproved": true}).then((_) {
                  //               print("success!");
                  //             });
                  //           })
                  //     ],
                  //   ),
                  // );
                },
              );
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
