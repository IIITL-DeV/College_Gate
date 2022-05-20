import 'package:college_gate/UI/warden/viewimage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class noNotices extends StatefulWidget {
  const noNotices({Key? key}) : super(key: key);

  @override
  _noNoticesState createState() => _noNoticesState();
}

class _noNoticesState extends State<noNotices> {
  var stream;
  @override
  approvesendMail(
      String phone, String studentemail, String date, String time) async {
    final Email email = Email(
      body:
          'Your appointment with $studentemail on $time, $date has been approved.',
      subject: 'Appointment Booked!',
      recipients: [phone],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  }

  declinesendMail(
      String phone, String studentemail, String date, String time) async {
    final Email email = Email(
      body:
          'Your appointment with $studentemail on $time, $date has been declined.',
      subject: 'Request Declined!',
      recipients: [phone],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  }

  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("studentGuest")
        .doc((FirebaseAuth.instance.currentUser!).email)
        .collection("guestUser")
        .where("gentryisapproved", isEqualTo: false)
        .snapshots();
  }

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
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    Text("No Requests",
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
                      children: [
                        ListTile(
                          onTap: () {}, //Zoom Image Function
                          //name
                          title: Text(
                            "${chatItem["guestname"]}",
                            style: TextStyle(
                                fontSize: cardheight * 0.137, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "wants to meets you on ${chatItem["guestentrytime"]}, ${chatItem["guestentrydate"]}",
                            style: TextStyle(fontSize: cardheight * 0.102),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(cardheight * 0.1,0,cardheight * 0.1,0),
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
                                onPressed: () {
                                  approvesendMail(
                                          chatItem["guestphone"],
                                          chatItem["vistingroll"],
                                          chatItem["guestentrydate"],
                                          chatItem["guestentrytime"])
                                      .whenComplete(() {
                                    setState(() {});
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text('Guest Notified')),
                                    );
                                  });

                                  FirebaseFirestore.instance
                                      .collection("studentGuest")
                                      .doc(
                                          (FirebaseAuth.instance.currentUser!)
                                              .email)
                                      .collection("guestUser")
                                      .doc(chatItem["guestphone"])
                                      .collection("gentryisapproved")
                                      .doc()
                                      .update({
                                    "gentryisapproved": true
                                  }).then((_) {
                                    print("success!");
                                  });
                                  FirebaseFirestore.instance
                                      .collection("studentGuest")
                                      .doc(
                                          (FirebaseAuth.instance.currentUser!)
                                              .email)
                                      .collection("guestUser")
                                      .doc(chatItem["guestphone"])
                                      .update({
                                    "gentryisapproved": true
                                  }).then((_) {
                                    print("success!");
                                  });
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
                                  // FirebaseFirestore.instance
                                  //     .collection("studentGuest")
                                  //     .doc(
                                  //         (FirebaseAuth.instance.currentUser!)
                                  //             .email)
                                  //     .collection("guestUser")
                                  //     .doc(chatItem["guestphone"])
                                  //     .collection("gentryisapproved")
                                  //     .doc()
                                  //     .update({
                                  //   "gentryisapproved": null
                                  // }).then((_) {
                                  //   print("success!");
                                  // });
                                  // FirebaseFirestore.instance
                                  //     .collection("studentGuest")
                                  //     .doc(
                                  //         (FirebaseAuth.instance.currentUser!)
                                  //             .email)
                                  //     .collection("guestUser")
                                  //     .doc(chatItem["guestphone"])
                                  //     .update({
                                  //   "gentryisapproved": null
                                  // }).then((_) {
                                  //   print("success!");
                                  // });
                                },
                                child: Text(
                                  "Decline",
                                  style: TextStyle(
                                      fontSize: cardheight * 0.12, color: Colors.red[700],),
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
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }
}
