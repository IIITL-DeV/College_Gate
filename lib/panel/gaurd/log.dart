import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/panel/warden/viewimage.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class guardLog extends StatefulWidget {
  @override
  _guardLogState createState() => _guardLogState();
}

class _guardLogState extends State<guardLog>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          // give the tab bar a height [can change hheight to preferred height]
          Container(
            height: 58.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                25.r,
              ),
            ),
            child: TabBar(
              controller: _tabController!,
              // give the indicator a decoration (color and border radius)
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  0.r,
                ),
                color: Colors.grey[300],
              ),

              labelColor: Color(0Xff15609c),
              unselectedLabelColor: Color(0XffD4D4D4),
              tabs: [
                // first tab [you can add an icon using the icon property]
                Tab(
                  text: 'Student',
                  // height: heightMobile * 0.4,
                ),

                // second tab [you can add an icon using the icon property]
                Tab(
                  text: 'Guest',
                ),
              ],
            ),
          ),

          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                //guard_requests(),
                gaurdStudentLog(),

                // second tab bar view widget
                //guard_entryrequests(),
                guardGuestLog(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class gaurdStudentLog extends StatefulWidget {
  // const guard_profile({Key? key}) : super(key: key);

  @override
  _gaurdStudentLogState createState() => _gaurdStudentLogState();
}

class _gaurdStudentLogState extends State<gaurdStudentLog> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("studentUser")
        .where("exitisapproved", isEqualTo: true)
        .where("purpose", isEqualTo: "Outing")
        .orderBy("date", descending: true)
        .orderBy("time", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {

    // final tab = new TabBar(tabs: <Tab>[
    //   new Tab(text: "Exit Requests"),
    //   new Tab(text: "Entry Requests"),
    // ]);
    return Scaffold(
        // appBar: new PreferredSize(
        //   preferredSize: tab.preferredSize,
        //   child: new Card(
        //     //elevation: 26.0,
        //     // color: Color(0Xff14619C),
        //     child: tab,
        //   ),
        // ),
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
                      Text("No Logs",
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
                padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                child: Card(
                  elevation: 2.5,
                  child: SizedBox(
                    height: 75.h,
                    //width: widthMobile * 0.9,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          onTap: null, //Zoom Image Function
                          //name
                          title: Text(
                            "${chatItem["name"]}",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
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
                                  tag: chatItem["idcard"],
                                  child: Image.network("${chatItem["idcard"]}",
                                      fit: BoxFit.contain),
                                ),
                                onTap: () {
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

class guardGuestLog extends StatefulWidget {
  const guardGuestLog({Key? key}) : super(key: key);

  @override
  _guardGuestLogState createState() => _guardGuestLogState();
}

class _guardGuestLogState extends State<guardGuestLog> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("guestRegister")
        .where("entryisapproved", isEqualTo: true)
        .orderBy("entrydate", descending: true)
        .orderBy("entrytime", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.1;

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
                      Text("No Logs",
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
                padding: EdgeInsets.all(heightMobile * 0.01),
                child: Card(
                  elevation: 2.5,
                  child: SizedBox(
                    height: 70.h,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Text(
                                "${chatItem["name"]}",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          //Phone number and Time
                          subtitle: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Icon(
                                Icons.directions_car,
                                size: 12.sp,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                "${chatItem["vehicleno"]}",
                                style: TextStyle(fontSize: 13.sp),
                              ),
                              // SizedBox(
                              //   height: cardheight * 0.03,
                              // ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Icon(
                                Icons.access_alarm,
                                size: 12.sp,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                "${chatItem["entrytime"]} | ${chatItem["entrydate"]}",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  backgroundColor: Color(0XffD1F0E8),
                                ),
                              ),
                            ],
                          )),
                          trailing: Transform.rotate(
                            angle: 180 * math.pi / 180,
                            child: IconButton(
                              onPressed: () {
                                DateTime times = DateTime.now();
                                FirebaseFirestore.instance
                                    .collection('guestRegister')
                                    .doc(chatItem["name"]! +
                                        chatItem["vehicleno"]!)
                                    .update({
                                  'exitdate':
                                      DateFormat('dd-MM-yyyy').format(times),
                                  'exittime':
                                      DateFormat('HH:mm a').format(times),
                                  'entryisapproved': false,
                                });
                              },
                              icon: Icon(
                                CupertinoIcons.square_arrow_left,
                                color: Color(0Xff19B38D),
                                size: 25.sp,
                              ),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w)
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
      },
    ));
  }
}
