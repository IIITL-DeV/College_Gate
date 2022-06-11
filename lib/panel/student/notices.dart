import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/student/no_notices.dart';
import 'package:college_gate/panel/student/readytogo.dart';
import 'package:college_gate/panel/student/requestpending.dart';
import 'package:college_gate/panel/student/welcomeback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

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
  @override
  approvesendMail(
    String guestemail,
    String time,
    String date,
  ) async {
    final Email email = Email(
      body: 'I confirm your appointment with me at $time on $date.',
      subject: 'Appointment Booked!',
      recipients: [guestemail],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  }

  declinesendMail(String guestemail, String date, String time) async {
    final Email email = Email(
      body: "I won't be available at $time on $date.",
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
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.16;
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
                    padding: EdgeInsets.all(heightMobile * 0.008),
                    child: Card(
                      elevation: 3.5,
                      child: SizedBox(
                        height: cardheight * 1.1,
                        width: widthMobile * 0.9,
                        child: ListView(
                          children: [
                            ListTile(
                              // onTap: () {}, //Zoom Image Function
                              // //name
                              title: Text(
                                "${chatItem["guestname"]}",
                                style: TextStyle(
                                    fontSize: cardheight * 0.137,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "wants to meets you on ${DateFormat('HH:mm').format(chatItem["guestappointdatetime"].toDate())} on ${DateFormat('dd-MM-yyyy').format(chatItem["guestappointdatetime"].toDate())}",
                                style: TextStyle(fontSize: cardheight * 0.102),
                              ),
                              // contentPadding: EdgeInsets.fromLTRB(
                              //     cardheight * 0.1, 0, cardheight * 0.1, 0),
                            ),

                            //Accept, Decline button
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: cardheight * 0.32,
                                  width: widthMobile * 0.42,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await approvesendMail(
                                              chatItem["guestemail"],
                                              DateFormat('HH:mm')
                                                  .format(chatItem[
                                                          "guestappointdatetime"]
                                                      .toDate())
                                                  .toString(),
                                              DateFormat('dd-MM-yyyy')
                                                  .format(chatItem[
                                                          "guestappointdatetime"]
                                                      .toDate())
                                                  .toString())
                                          .whenComplete(() {
                                        setState(() {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Request Accepted')),
                                        );
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
                                        fontSize: cardheight * 0.12,
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
                                  width: widthMobile * 0.03,
                                ),
                                Container(
                                  height: cardheight * 0.3,
                                  width: widthMobile * 0.42,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      declinesendMail(
                                              chatItem["guestemail"],
                                              DateFormat('HH:mm')
                                                  .format(chatItem[
                                                          "guestappointdatetime"]
                                                      .toDate())
                                                  .toString(),
                                              DateFormat('dd-MM-yyyy')
                                                  .format(chatItem[
                                                          "guestappointdatetime"]
                                                      .toDate())
                                                  .toString())
                                          .whenComplete(() {
                                        setState(() {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Request Declined')),
                                        );
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
                                        fontSize: cardheight * 0.12,
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
