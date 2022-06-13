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
        .where("purpose", isEqualTo: "Outing")
        .where("entryisapproved", isEqualTo: "EntryPending")
        .orderBy("entrydatetime", descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // double widthMobile = MediaQuery.of(context).size.width;
    // double heightMobile = MediaQuery.of(context).size.height;
    // double cardheight = heightMobile * 0.195;
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
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                child: Card(
                  elevation: 3.5,
                  child: SizedBox(
                    height: 135.h,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          title: Text(
                            "${chatItem["name"]}",
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
                                    "${chatItem["phone"]}",
                                    style: TextStyle(fontSize: 11.sp),
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
                              minWidth: 30.w,
                              minHeight: 50.h,
                              maxWidth: 60.h,
                              maxHeight: 55.h,
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
                              SizedBox(height: 15.h),
                              Text(
                                " ${chatItem["hostelno"]}/${chatItem["room"]}",
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                "${chatItem["enrollment"]}",
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.w,vertical: 5.h),
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
                                  height: 38.h,
                                  width: 150.w,
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
                                        "purpose": "Outing",
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
