import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:college_gate/panel/warden/viewimage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class guard_entryrequests extends StatefulWidget {
  // const guard_requests({Key? key}) : super(key: key);

  @override
  _guard_entryrequestsState createState() => _guard_entryrequestsState();
}

class _guard_entryrequestsState extends State<guard_entryrequests> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("studentUser")
        // .where("purpose", isEqualTo: "Outing")
        .where("entryisapproved", isEqualTo: "EntryPending")
        // .orderBy("exitdatetime", descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.195;
    return Scaffold(
        body: StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          int value;
          value = snapshot.data!.docs.length;
          if (value == 0 || value == null) {
            print("issssss$value");
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 100.h),
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
                            "${chatItem["name"]}",
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
                                    "${chatItem["phone"]}",
                                    style:
                                        TextStyle(fontSize: cardheight * 0.09),
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height: cardheight * 0.03,
                              // ),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Icons.access_alarm,
                              //       size: cardheight * 0.08,
                              //     ),
                              //     SizedBox(
                              //       width: widthMobile * 0.02,
                              //     ),
                              //     Text(
                              //       "${chatItem["time"]} | ${chatItem["date"]}",
                              //       style: TextStyle(
                              //         fontSize: cardheight * 0.08,
                              //         backgroundColor: Color(0XffD1F0E8),
                              //       ),
                              //     ),
                              //   ],
                              // )
                            ],
                          )),
                          //Id Image
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: widthMobile * 0.07,
                              minHeight: cardheight * 0.25,
                              maxWidth: widthMobile * 0.15,
                              maxHeight: cardheight * 0.45,
                            ),
                            child: GestureDetector(
                                child: Hero(
                                  tag: chatItem["idcard"]!,
                                  child: Image.network("${chatItem["idcard"]}",
                                      fit: BoxFit.contain),
                                ),
                                onTap: () async {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return viewImage(chatItem["idcard"]);
                                  }));
                                }),
                          ),
                          //Room Number
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(height: cardheight * 0.07),
                              Text(
                                "${chatItem["hostelno"]}/${chatItem["room"]}",
                                style: TextStyle(
                                    fontSize: cardheight * 0.09,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: cardheight * 0.02),
                              Text(
                                "${chatItem["enrollment"]}",
                                style: TextStyle(
                                    fontSize: cardheight * 0.09,
                                    fontWeight: FontWeight.bold),
                              ),
                              //SizedBox(height: cardheight * 0.1,)
                            ],
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              cardheight * 0.1,
                              cardheight * 0.1,
                              cardheight * 0.1,
                              cardheight * 0.0),
                        ),
                        // SizedBox(
                        //   height: cardheight * 0.03,
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
                                      await FirebaseFirestore.instance
                                          .collection("studentRegister")
                                          .doc()
                                          .set({
                                        "name": chatItem["name"],
                                        "enrollment": chatItem["enrollment"],
                                        "exitdatetime":
                                            chatItem["exitdatetime"],
                                        "entrydatetime": DateTime.now(),
                                        "purpose": chatItem["purpose"] == null
                                            ? "Home"
                                            : chatItem["purpose"],
                                      });

                                      await FirebaseFirestore.instance
                                          .collection("studentUser")
                                          .doc(chatItem["email"])
                                          .update({
                                        "entryisapproved": "EntryApproved",
                                        "exitdatetime": null,
                                        "entrydatetime": null,
                                        "exitisapproved": null,
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
                                          MaterialStateProperty.all<Color>(
                                              Color(0Xff19B38D)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: widthMobile * 0.05,
                                ),
                                Container(
                                  height: cardheight * 0.25,
                                  width: widthMobile * 0.42,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("studentUser")
                                          .doc(chatItem["email"])
                                          .update({
                                        "entryisapproved": null
                                      }).then((_) {
                                        print("success!");
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
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
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
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }
}
