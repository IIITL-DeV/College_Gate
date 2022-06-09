import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class guestRegister extends StatefulWidget {
  const guestRegister({Key? key}) : super(key: key);

  @override
  _guestRegisterState createState() => _guestRegisterState();
}

class _guestRegisterState extends State<guestRegister> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("guestRegister")
        .orderBy("entrydate", descending: true)
        .orderBy("entrytime", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {

    // final tab = new TabBar(tabs: <Tab>[
    //   new Tab(text: "Exit Requests"),
    //   new Tab(text: "Entry Requests"),
    // ]);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 56.h,
          backgroundColor: Color(0Xff15609c),
          centerTitle: true,
          title: Text(
            "Guest Register",
            style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w500),
          ),
        ),
        // AppBar(
        //     backgroundColor: Color(0Xff15609c),
        //     title: Text(
        //       "College Gate",
        //       style: TextStyle(fontSize: heightMobile * 0.025),
        //     ),
        //     actions: [
        //       InkWell(
        //         onTap: () {
        //           AuthMethods().logout().then((s) {
        //             Navigator.pushReplacement(context,
        //                 MaterialPageRoute(builder: (context) => SignIn()));
        //           });
        //         },
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
                          Text("No Entry",
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final chatItem = snapshot.data!.docs[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                    child: Card(
                      elevation: 2.5,
                      child: SizedBox(
                        height: 80.h,
                        child: ListView(
                          children: [
                            ListTile(
                              title: Text(
                                "${chatItem["name"]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text("${chatItem["vehicleno"]}",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                  )),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                            ),
                            Row(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 12.w,),
                                Text("${chatItem["purpose"]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                    )),
                                //SizedBox(height: 5),
                                SizedBox(width: 8.w,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [ //SizedBox(height: 5),
                                    Icon(
                                      Icons.access_alarm,
                                      size: 13.sp,
                                      color:
                                      Color.fromARGB(255, 22, 180, 140),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),

                                    Text(
                                      chatItem["entrytime"] == null
                                          ? "OUT | OUT"
                                          : "${chatItem["entrytime"]} | ${chatItem["entrydate"]}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    ),
                                    SizedBox(width: 4.w,),
                                    Icon(
                                      Icons.arrow_forward,
                                      color:
                                      Color.fromARGB(255, 22, 180, 140),
                                      size: 13.sp,
                                    ),
                                    SizedBox(width: 4.w,),

                                    Text(
                                      chatItem["exittime"] == null
                                          ? "IN | IN"
                                          : "${chatItem["exittime"]} | ${chatItem["exitdate"]}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
