import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:college_gate/panel/warden/viewimage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

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
        .where("entryisapproved", isEqualTo: false)
        .where("purpose", isEqualTo: "Outing")
        .orderBy("entrydate", descending: false)
        .orderBy("entrytime", descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.195;
    if(cardheight>155) cardheight = 155;
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
                      SizedBox(height: 30.h,),
                      Text("No Requests",
                          style: TextStyle(
                            fontSize: 28.sp,
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
                  elevation: 2.5,
                  child: SizedBox(
                    height: 110.h,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          title: Text(
                            "${chatItem["name"]}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18.sp,
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
                                        size: 12.sp,
                                      ),
                                      SizedBox(
                                        width: 7.w,
                                      ),
                                      Text(
                                        "${chatItem["phone"]}",
                                        style:
                                        TextStyle(fontSize: 13.sp),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_alarm,
                                        size: 12.sp,
                                      ),
                                      SizedBox(
                                        width: 7.h,
                                      ),
                                      Text(
                                        "${chatItem["time"]} | ${chatItem["date"]}",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          backgroundColor: Color(0XffD1F0E8),
                                        ),
                                      ),
                                    ],
                                  )
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
                              SizedBox(height: 9.h),
                              Text(
                                "${chatItem["room"]}",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                "${chatItem["enrollment"]}",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
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
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("studentUser")
                                          .doc(chatItem["email"])
                                          .update({
                                        "entryisapproved": null,
                                        "exitisapproved": null
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
