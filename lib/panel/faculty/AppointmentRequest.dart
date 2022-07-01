import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';

class AppointmentRequest extends StatefulWidget {
  const AppointmentRequest({Key? key}) : super(key: key);

  @override
  _AppointmentRequestState createState() => _AppointmentRequestState();
}

class _AppointmentRequestState extends State<AppointmentRequest> {

  String? officenumber, phonenumber, facultyName, facultyEmail, name;
  late String _hour, _minute, _time;

  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();


  reschedulesendMail(
    String guestemail,
    String date,
    String phonenumber,
    String officenumber,
    String facultyName,
    String facultyEmail,
  ) async {
    final Email email = Email(
      body: '<p>Greetings for the day!</p> <p>It is informed to you that $facultyName has rescheduled your appointment request. He/She will be available on <b>$date</b> in Room no: $officenumber.<br>Hope to see you soon! <br>Thank You.</p><p>For further information/clarifications-<br>Phone No.: +91$phonenumber <br>Email: $facultyEmail</p>',
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
      firstDate: DateTime.now(),
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
        _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);

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
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute), [
          hh,
          ':',
          nn,
        ]).toString();
        appointmentReschedule(context, name, email);
      });
    //Navigator.of(context).pop();
  }

  Future<dynamic> appointmentReschedule(
      BuildContext context, String name, String email) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Reschedule",
              style: TextStyle(fontSize: 16.sp, color: Color(0Xff15609c)),
            ),
            content: Container(
              child: Text(
                'Reschedule Appointment with $name at ${_timeController.text} on ${_dateController.text}.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.sp,
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
                            .collection('facultyUser')
                            .doc((FirebaseAuth.instance.currentUser!).email)
                            .collection("guestemail")
                            .doc(email)
                            .update({
                          'guestappointdatetime': DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute),
                          'appointisapproved': true,
                        });
                        FirebaseFirestore.instance
                            .collection('facultyUser')
                            .doc((FirebaseAuth.instance.currentUser)!.email)
                            .get()
                            .then((value) {
                          setState(() {
                            officenumber = value.data()!['officeno'].toString();
                            phonenumber = value.data()!['phone'].toString();
                            facultyName = value.data()!['name'].toString();
                            facultyEmail = value.data()!['email'].toString();
                          });
                          reschedulesendMail(
                                  email,
                                  "${DateFormat('HH:mm').format(
                                    DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        selectedTime.hour,
                                        selectedTime.minute),
                                  )} | ${DateFormat('dd-MM-yyyy').format(
                                    DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        selectedTime.hour,
                                        selectedTime.minute),
                                  )}",
                                  phonenumber!,
                                  officenumber!, facultyName!, facultyEmail!,

                          )
                              .whenComplete(() {
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Guest Notified')));
                          });
                          flutterToast("Rescheduled Successfully");
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0Xff19B38D),
                        ),
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel",
                          style: TextStyle(
                              fontSize: 14.sp, color: Colors.red[700]))),
                ],
              )
            ],
          );
        });
  }

  //////
  var stream;



  void initState() {
    ////
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute), [
      hh,
      ':',
      nn,
    ]).toString();

    ///
    super.initState();
    // getfacultyDetails;
    stream = FirebaseFirestore.instance
        .collection("facultyUser")
        .doc((FirebaseAuth.instance.currentUser!).email)
        .collection("guestemail")
        .where("appointisapproved", isEqualTo: false)
        .orderBy("guestappointdatetime", descending: false)
        // .orderBy("guestappointtime", descending: true)
        .snapshots();
  }

  approvesendMail(String guestemail, String date, String? phonenumber,
      String? officenumber,String? facultyName,
      String? facultyEmail,) async {
    final Email email = Email(
      body: '<p>Greetings for the day!</p> <p>It is informed to you that $facultyName has accepted your appointment request. He/She will be available on <b>$date</b> in Room no: $officenumber.<br>Hope to see you soon! <br>Thank You.</p><p>For further information/clarifications-<br>Phone No.: +91$phonenumber <br>Email: $facultyEmail</p>',
      subject: 'Appointment Booked!',
      recipients: [guestemail],
      isHTML: true,
    );
    await FlutterEmailSender.send(email);
  }

  declinesendMail(String guestemail, String? phonenumber, String? facultyName, String? facultyEmail) async {
    final Email email = Email(
      body: '<p>Greetings for the day!</p> <p>It is informed to you that $facultyName has cancelled your appointment request due to some unavoidable circumstances. Please accept sincere apologies for the inconvenience caused.<br>Hope to see you soon! <br>Thank You.</p><p>For further information/clarifications-<br>Phone No.: +91$phonenumber <br>Email: $facultyEmail</p>',

      subject: 'Request Declined!',
      recipients: [guestemail],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 56.h,
          backgroundColor: Color(0Xff15609c),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 21.sp, child: Image.asset("assets/cg_white.png")),
              SizedBox(
                width: 12.w,
              ),
              Text("College Gate", style: TextStyle(fontSize: 21.sp)),
              //SizedBox(width: 50.w,),
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
                if (value == 0) {
                  print("issssss$value");
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 150.h),
                        child: Column(
                          children: <Widget>[
                            //SizedBox(height: 266.h),
                            Image.asset(
                              'assets/nonotices.png',
                              //fit: BoxFit.fitWidth,
                              width: 228.w,
                              height: 228.h,
                              alignment: Alignment.center,
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Text("No Requests",
                                style: TextStyle(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0Xff14619C),
                                )),
                          ],
                        ),
                      ));
                }
                return ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final chatItem = snapshot.data!.docs[index];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                      child: Card(
                        elevation: 2,
                        child: SizedBox(
                          height: 135.h,
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              ListTile(
                                title: Text(
                                  "${chatItem["guestname"]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                //Phone number and Time
                                subtitle: Container(
                                    child: Column(
                                  children: [
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_call,
                                          size: 11.sp,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          "${chatItem["guestphone"]}",
                                          style: TextStyle(fontSize: 11.sp),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_alarm,
                                          size: 11.sp,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          chatItem["guestappointdatetime"] ==
                                                  null
                                              ? "NA | NA"
                                              : "${DateFormat('HH:mm').format(chatItem["guestappointdatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["guestappointdatetime"].toDate())}",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            backgroundColor: Color(0XffD1F0E8),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                //Id Image
                                //Room Number
                                trailing: SizedBox(
                                  width: 78.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      //SizedBox(height: cardheight * 0.07),
                                      SizedBox(height: 15.h),
                                      Text(
                                        chatItem["isStudent"]
                                            ? "Student"
                                            : "Guest",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      // SizedBox(height: cardheight * 0.07),
                                      SizedBox(height: 3.h),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Description",
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color:
                                                            Color(0Xff15609c)),
                                                  ),
                                                  content: Container(
                                                    child: Text(
                                                      '${chatItem["guestpurpose"]}',
                                                      //softWrap: true,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons
                                                  .arrowtriangle_down_circle_fill,
                                              size: 12.sp,
                                              color: Color(0Xff14619C),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              "Description",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Color(0Xff15609c)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // TextButton.icon(
                                      //     onPressed: () {
                                      //       showDialog(
                                      //           context: context,
                                      //           builder:
                                      //               (BuildContext context) {
                                      //             return AlertDialog(
                                      //               title: Text(
                                      //                 "Description",
                                      //                 style: TextStyle(
                                      //                     fontSize: 16.sp,
                                      //                     color: Color(
                                      //                         0Xff15609c)),
                                      //               ),
                                      //               content: Container(
                                      //                 child: Text(
                                      //                   '${chatItem["guestpurpose"]}',
                                      //                   //softWrap: true,
                                      //                   style: TextStyle(
                                      //                     color: Colors.black,
                                      //                     fontSize: 13.sp,
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             );
                                      //           });
                                      //     },
                                      //     icon: Icon(
                                      //       CupertinoIcons
                                      //           .arrowtriangle_down_circle_fill,
                                      //       size: 12.sp,
                                      //       color: Color(0Xff14619C),
                                      //     ),
                                      //     label: Text(
                                      //       "Description",
                                      //       style: TextStyle(
                                      //           fontSize: 12.sp,
                                      //           color: Color(0Xff15609c)),
                                      //     ))
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
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 5.h),
                              ),
                              // SizedBox(
                              //   height: cardheight * 0.05,
                              // ),
                              //Accept, Decline button
                              Column(
                                children: [
                                  Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 38.h,
                                        width: 150.w,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            FirebaseFirestore.instance
                                                .collection('facultyUser')
                                                .doc(await (FirebaseAuth
                                                        .instance.currentUser)!
                                                    .email)
                                                .get()
                                                .then((value) {
                                              setState(() {
                                                name = value
                                                    .data()!['name']
                                                    .toString();
                                                officenumber = value
                                                    .data()!['officeno']
                                                    .toString();
                                                phonenumber = value
                                                    .data()!['phone']
                                                    .toString();
                                                facultyName = value
                                                    .data()!['name']
                                                    .toString();
                                                facultyEmail = value
                                                    .data()!['email']
                                                    .toString();

                                                print("myyyyyyyyyyyyy${name}");
                                                approvesendMail(
                                                        chatItem["guestemail"],
                                                        "${DateFormat('HH:mm').format(chatItem["guestappointdatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["guestappointdatetime"].toDate())}",
                                                        phonenumber,
                                                        officenumber, facultyName, facultyEmail,

                                                )
                                                    .whenComplete(() {
                                                  setState(() {});
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Guest Notified')),
                                                  );
                                                });
                                              });
                                            });

                                            await FirebaseFirestore.instance
                                                .collection("facultyUser")
                                                .doc((FirebaseAuth
                                                        .instance.currentUser!)
                                                    .email)
                                                .collection("guestemail")
                                                .doc(chatItem["guestemail"])
                                                .update({
                                              "appointisapproved": true
                                            }).then((_) {
                                              print("success!");
                                            });
                                          },
                                          child: Text(
                                            "Accept",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Color(0Xff19B38D)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Container(
                                        height: 38.h,
                                        width: 150.w,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    elevation: 3,
                                                    title: Column(
                                                      children: [
                                                        Text(
                                                          "Are you sure you want to decline?",
                                                          style: TextStyle(
                                                              fontSize: 16.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              "Description",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.sp,
                                                                  color: Color(
                                                                      0Xff15609c)),
                                                            ))
                                                      ],
                                                    ),
                                                    content: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        color: Colors.white70,
                                                        border: Border.all(
                                                          width: 0.1,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        '${chatItem["guestpurpose"]}',
                                                        //softWrap: true,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: 38.h,
                                                                width: 120.w,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _selectDate(
                                                                        context,
                                                                        chatItem["guestname"]
                                                                            .toString(),
                                                                        chatItem["guestemail"]
                                                                            .toString());
                                                                  },
                                                                  child: Text(
                                                                    "Reschedule",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14.sp,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        Color(
                                                                            0Xff19B38D)),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 10.w),
                                                              Container(
                                                                height: 38.h,
                                                                width: 120.w,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () async{
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    FirebaseFirestore.instance
                                                                        .collection('facultyUser')
                                                                        .doc(await (FirebaseAuth
                                                                        .instance.currentUser)!
                                                                        .email)
                                                                        .get()
                                                                        .then((value) {
                                                                      setState(() {
                                                                        phonenumber = value
                                                                            .data()!['phone']
                                                                            .toString();
                                                                        facultyName = value
                                                                            .data()!['name']
                                                                            .toString();
                                                                        facultyEmail = value
                                                                            .data()!['email']
                                                                            .toString();

                                                                        print("myyyyyyyyyyyyy${name}");
                                                                        declinesendMail(
                                                                          chatItem[
                                                                          "guestemail"],
                                                                          phonenumber, facultyName, facultyEmail
                                                                        )
                                                                            .whenComplete(() {
                                                                          setState(() {});
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                                content: Text(
                                                                                    'Guest Notified')),
                                                                          );
                                                                        });
                                                                      });
                                                                    });

                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "facultyUser")
                                                                        .doc((FirebaseAuth.instance.currentUser!)
                                                                            .email)
                                                                        .collection(
                                                                            "guestemail")
                                                                        .doc(chatItem[
                                                                            "guestemail"])
                                                                        .delete()
                                                                        .then(
                                                                            (_) {
                                                                      print(
                                                                          "Deleted succesfully!");
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                    "Decline",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14.sp,
                                                                      color: Colors
                                                                              .red[
                                                                          700],
                                                                    ),
                                                                  ),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                          SizedBox(
                                                            height: 10.h,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text(
                                            "Decline",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.red[700],
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                                  SizedBox(
                                    height: 10.h,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  // Future<dynamic> dialogBox() {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         double widthMobile = MediaQuery.of(context).size.width;
  //         double heightMobile = MediaQuery.of(context).size.height;
  //         return AlertDialog(
  //           title: Text(
  //             "Description",
  //             style: TextStyle(
  //                 fontSize: heightMobile * 0.027, color: Color(0Xff15609c)),
  //           ),
  //           content: Container(
  //             // constraints: BoxConstraints(
  //             //   maxHeight: double.infinity,
  //             // ),
  //             child: Text(
  //               'okii',
  //               //softWrap: true,
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: heightMobile * 0.021,
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // Future<dynamic> rescheduleBox() {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         double widthMobile = MediaQuery.of(context).size.width;
  //         double heightMobile = MediaQuery.of(context).size.height;
  //         return AlertDialog(
  //           elevation: 3,
  //           title: Column(
  //             children: [
  //               Text(
  //                 "Are you sure you want to decline?",
  //                 style: TextStyle(fontSize: heightMobile * 0.026),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text(
  //                     "Description",
  //                     style: TextStyle(
  //                         fontSize: heightMobile * 0.018,
  //                         color: Color(0Xff15609c)),
  //                   ))
  //             ],
  //           ),
  //           content: Container(
  //             padding: const EdgeInsets.all(10.0),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(8.0),
  //               color: Colors.white70,
  //               border: Border.all(
  //                 width: 0.1,
  //               ),
  //             ),
  //             child: Text(
  //               'Hellr...i.Jagnik...Hellr...i.Jagnik...Hellr...i.Jagnik...Hellr...i.Jagnik....Hellr...i.Jagnik...Hellr...i.Jagnik....Hellr...i.Jagnik....Hellr...i.Jagnik',
  //               //softWrap: true,
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: heightMobile * 0.022,
  //               ),
  //             ),
  //           ),
  //           actions: [
  //             Column(
  //               children: [
  //                 Container(
  //                     child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Container(
  //                       height: MediaQuery.of(context).size.height * 0.05,
  //                       width: MediaQuery.of(context).size.width * 0.35,
  //                       child: ElevatedButton(
  //                         onPressed: () {
  //                           _selectDate(context);
  //                         },
  //                         child: Text(
  //                           "Reschedule",
  //                           style: TextStyle(
  //                             fontSize:
  //                                 MediaQuery.of(context).size.height * 0.02,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                         style: ButtonStyle(
  //                           backgroundColor: MaterialStateProperty.all<Color>(
  //                               Color(0Xff19B38D)),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: MediaQuery.of(context).size.width * 0.03,
  //                     ),
  //                     Container(
  //                       height: MediaQuery.of(context).size.height * 0.05,
  //                       width: MediaQuery.of(context).size.width * 0.35,
  //                       child: ElevatedButton(
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: Text(
  //                           "Decline",
  //                           style: TextStyle(
  //                             fontSize:
  //                                 MediaQuery.of(context).size.height * 0.02,
  //                             color: Colors.red[700],
  //                           ),
  //                         ),
  //                         style: ButtonStyle(
  //                           backgroundColor:
  //                               MaterialStateProperty.all<Color>(Colors.white),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 )),
  //                 SizedBox(
  //                   height: 10,
  //                 )
  //               ],
  //             ),
  //           ],
  //         );
  //       });
  // }

}
