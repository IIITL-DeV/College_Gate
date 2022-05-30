import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class AppointmentRequest extends StatefulWidget {
  const AppointmentRequest({Key? key}) : super(key: key);

  @override
  _AppointmentRequestState createState() => _AppointmentRequestState();
}

class _AppointmentRequestState extends State<AppointmentRequest> {
  var stream;

  String? officenumber, phonenumber, name;

  void initState() {
    super.initState();
    // getfacultyDetails;
    stream = FirebaseFirestore.instance
        .collection("facultyGuest")
        .doc((FirebaseAuth.instance.currentUser!).email)
        .collection("guestemail")
        .where("appointisapproved", isEqualTo: false)
        .snapshots();
  }

  @override
  approvesendMail(String guestemail, String date, String time,
      String? phonenumber, String? officenumber) async {
    final Email email = Email(
      body:
          "I hereby confirm our appointment at $time, $date in Admin block at "
          "Office number: ${officenumber}."
          " Contact number: ${phonenumber}.",
      subject: 'Appointment Booked!',
      recipients: [guestemail],
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

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.2;
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
                          Text("No Request",
                              style: TextStyle(
                                fontSize: heightMobile * 0.04,
                                fontWeight: FontWeight.w300,
                                color: Color(0Xff14619C),
                              )),
                        ],
                      ));
                }
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
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
                                    child: Column(
                                  children: [
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
                                    )
                                  ],
                                )),
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
                                                builder:
                                                    (BuildContext context) {
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
                                                          fontSize:
                                                              heightMobile *
                                                                  0.027,
                                                          color: Color(
                                                              0Xff15609c)),
                                                    ),
                                                    content: Container(
                                                      child: Text(
                                                        '${chatItem["guestpurpose"]}',
                                                        //softWrap: true,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              heightMobile *
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
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: cardheight * 0.25,
                                        width: widthMobile * 0.42,
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

                                                print("myyyyyyyyyyyyy${name}");
                                                approvesendMail(
                                                        chatItem["guestemail"],
                                                        chatItem[
                                                            "guestappointdate"],
                                                        chatItem[
                                                            "guestappointtime"],
                                                        phonenumber,
                                                        officenumber)
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
                                                .collection("facultyGuest")
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
                                              fontSize: cardheight * 0.1,
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
                                        width: widthMobile * 0.03,
                                      ),
                                      Container(
                                        height: cardheight * 0.25,
                                        width: widthMobile * 0.42,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  double widthMobile =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width;
                                                  double heightMobile =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height;
                                                  return AlertDialog(
                                                    elevation: 3,
                                                    title: Column(
                                                      children: [
                                                        Text(
                                                          "Are you sure you want to decline?",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  heightMobile *
                                                                      0.026),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              "Description",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      heightMobile *
                                                                          0.018,
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
                                                          fontSize:
                                                              heightMobile *
                                                                  0.022,
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
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.05,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                    "Reschedule",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.02,
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
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03,
                                                              ),
                                                              Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.05,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                    "Decline",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.02,
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
                                                            height: 10,
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
                                              fontSize: cardheight * 0.1,
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
                                    height: cardheight * 0.1,
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
  //                         onPressed: () {},
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
  //                         onPressed: () {},
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
