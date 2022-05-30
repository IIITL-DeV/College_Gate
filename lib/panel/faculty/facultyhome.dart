import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  /////// date time picker
  ///
  //late String _setTime, _setDate;

  late String _hour, _minute, _time;

  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context, String name) async {
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
        _selectTime(context,name);
      });
  }

  Future<Null> _selectTime(BuildContext context, String name) async {
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

        appointmentReschedule(context,name);
      });
    //Navigator.of(context).pop();
  }

  Future<dynamic> appointmentReschedule(BuildContext context,String name) {
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
                        Navigator.of(context).pop();
                        //Navigator.of(context).pop();
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
                        //Navigator.of(context).pop();
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

  void initState() {
    ////
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    ///
    super.initState();
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
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          //final chatItem = snapshot.data!.docs[index];
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
                        "Jagnik Chaurasiya",
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
                              "7856009040",
                              style: TextStyle(fontSize: cardheight * 0.09),
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
                              "11:05 | 19-05-2022",
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
                      trailing: Text(
                        "LIT2019059",
                        style: TextStyle(
                            fontSize: cardheight * 0.09,
                            fontWeight: FontWeight.bold),
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
                              _selectDate(context, "Jagnik Chaurasiya");
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
      ),
    );
  }
}
