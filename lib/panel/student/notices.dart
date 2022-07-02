import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/main.dart';
import 'package:college_gate/panel/aboutus.dart';
import 'package:college_gate/panel/student/no_notices.dart';
import 'package:college_gate/panel/student/readytogo.dart';
import 'package:college_gate/panel/student/requestpending.dart';
import 'package:college_gate/panel/student/welcomeback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class notices extends StatefulWidget {
  @override
  _noticesState createState() => _noticesState();
}

class _noticesState extends State<notices> {
  String? exitisapproved, entryisapproved;

  Future<void> getdetails() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).email)
        .get()
        .then((value) {
      setState(() {
        exitisapproved = value.data()!['exitisapproved'].toString();
        entryisapproved = value.data()!['entryisapproved'].toString();
      });
    });
  }

  // var stream;
  // bool exitstatus = false;
  // bool entrystatus = false;
  String? phonenumber, roomnumber, StudentName, StudentEmail, StudentRoll;
  @override
  approvesendMail(
    String guestemail,
    String date,
    String? phonenumber,
    String? roomnumber,
    String? StudentName,
    String? StudentEmail,
    String? StudentRoll,
  ) async {
    final Email email = Email(
      body:
          '<p>Greetings for the day!</p> <p>It is to inform you that your appointment has scheduled on <b>$date</b> in Room no: $roomnumber.<br>Please be present accordingly! <br>Thank You.</p><p>Regards,<br>$StudentName - $StudentRoll <br>Phone No.: +91$phonenumber <br>Email: $StudentEmail</p>',
      subject: 'Appointment Booked!',
      recipients: [guestemail],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  }

  declinesendMail(String guestemail, String date, String? phonenumber,
      String? StudentName, String? StudentEmail, String? StudentRoll) async {
    final Email email = Email(
      body:
          '<p>Greetings for the day!</p> <p>It is to inform you that your appointment cannot be scheduled at the moment due to unavoidable circumstances. Please accept sincere apologies for the inconvenience caused and try again later!. <br>Thank You.</p><p>Regards,<br>$StudentName - $StudentRoll <br>Phone No.: +91$phonenumber <br>Email: $StudentEmail</p>',
      subject: 'Request Declined!',
      recipients: [guestemail],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  }

  void initState() {
    super.initState();

    getdetails();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 56.h,
          backgroundColor: Color(0Xff15609c),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUs()));
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
          stream: FirebaseFirestore.instance
              .collection("studentUser")
              .doc((FirebaseAuth.instance.currentUser!).email)
              .collection("guestemail")
              .orderBy("guestappointdatetime", descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              int value;
              value = snapshot.data!.docs.length;
              if (value == 0) {
                if (exitisapproved == "ExitPending" ||
                    entryisapproved == "EntryPending") {
                  return requestpending();
                } else if (exitisapproved == "ExitApproved") {
                  return ReadytoGo();
                } else if (entryisapproved == "EntryApproved") {
                  return welcomeback();
                } else
                  return no_notices();
              }

              return ListView.builder(
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
                          children: [
                            ListTile(
                              // onTap: () {}, //Zoom Image Function
                              // //name
                              title: Text(
                                "${chatItem["guestname"]}",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "wants to meets you at ${DateFormat('HH:mm').format(chatItem["guestappointdatetime"].toDate())} on ${DateFormat('dd-MM-yyyy').format(chatItem["guestappointdatetime"].toDate())}",
                                style: TextStyle(fontSize: 13.sp),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 5.h),
                            ),

                            //Accept, Decline button
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
                                          .collection('studentUser')
                                          .doc(await (FirebaseAuth
                                                  .instance.currentUser)!
                                              .email)
                                          .get()
                                          .then((value) {
                                        setState(() {
                                          StudentName =
                                              value.data()!['name'].toString();
                                          StudentRoll = value
                                              .data()!['enrollment']
                                              .toString();
                                          StudentEmail =
                                              value.data()!['email'].toString();
                                          phonenumber =
                                              value.data()!['phone'].toString();
                                          roomnumber = value
                                                  .data()!['hostelno']
                                                  .toString() +
                                              '/' +
                                              value.data()!['room'].toString();

                                          approvesendMail(
                                                  chatItem["guestemail"],
                                                  "${DateFormat('HH:mm').format(chatItem["guestappointdatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["guestappointdatetime"].toDate())}",
                                                  phonenumber,
                                                  roomnumber,
                                                  StudentName,
                                                  StudentEmail,
                                                  StudentRoll)
                                              .whenComplete(() {
                                            setState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('Request Accepted')),
                                            );
                                          });
                                        });
                                      });

                                      await FirebaseFirestore.instance
                                          .collection("studentUser")
                                          .doc((FirebaseAuth
                                                  .instance.currentUser!)
                                              .email)
                                          .collection("guestemail")
                                          .doc(chatItem["guestemail"])
                                          .delete();
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
                                          MaterialStateProperty.all<Color>(
                                              Color(0Xff19B38D)),
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
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection('studentUser')
                                          .doc(await (FirebaseAuth
                                                  .instance.currentUser)!
                                              .email)
                                          .get()
                                          .then((value) {
                                        setState(() {
                                          StudentName =
                                              value.data()!['name'].toString();
                                          StudentRoll = value
                                              .data()!['enrollment']
                                              .toString();
                                          StudentEmail =
                                              value.data()!['email'].toString();
                                          phonenumber =
                                              value.data()!['phone'].toString();

                                          declinesendMail(
                                                  chatItem["guestemail"],
                                                  "${DateFormat('HH:mm').format(chatItem["guestappointdatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["guestappointdatetime"].toDate())}",
                                                  phonenumber,
                                                  StudentName,
                                                  StudentEmail,
                                                  StudentRoll)
                                              .whenComplete(() {
                                            setState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('Request Declined')),
                                            );
                                          });
                                        });
                                      });

                                      FirebaseFirestore.instance
                                          .collection("studentUser")
                                          .doc((FirebaseAuth
                                                  .instance.currentUser!)
                                              .email)
                                          .collection("guestemail")
                                          .doc(chatItem["guestemail"])
                                          .delete();
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
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
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
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
