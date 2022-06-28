import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/gaurd/entryrequest.dart';
import 'package:college_gate/panel/viewimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class guardRequestHome extends StatefulWidget {
  @override
  _guardRequestHomeState createState() => _guardRequestHomeState();
}

class _guardRequestHomeState extends State<guardRequestHome>
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
            height: 54.h,
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
                  0,
                ),
                color: Colors.grey[300],
              ),

              labelColor: Color(0Xff15609c),
              labelStyle: TextStyle(fontSize: 14.h),
              unselectedLabelColor: Color(0XffD4D4D4),
              tabs: [
                // first tab [you can add an icon using the icon property]
                Tab(
                  text: 'Exit Requests',
                  // height: heightMobile * 0.4,
                ),

                // second tab [you can add an icon using the icon property]
                Tab(
                  text: 'Entry Requests',
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
                guard_requests(),

                // second tab bar view widget
                guard_entryrequests(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class guard_requests extends StatefulWidget {
  // const guard_requests({Key? key}) : super(key: key);

  @override
  _guard_requestsState createState() => _guard_requestsState();
}

class _guard_requestsState extends State<guard_requests> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("studentUser")
        .where("exitisapproved", isEqualTo: "ExitPending")
        // .orderBy("exitdatetime", descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // double widthMobile = MediaQuery.of(context).size.width;
    // double heightMobile = MediaQuery.of(context).size.height;
    // double cardheight = heightMobile * 0.195;
    // //print(cardheight);
    // if (cardheight > 155) cardheight = 155;
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
                  elevation: 2,
                  child: SizedBox(
                    height: 135.h,
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text(
                            "${chatItem["name"]}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 5.h),
                        ),
                        // SizedBox(
                        //   height: 6.h,
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
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("studentUser")
                                          .doc(chatItem["email"])
                                          .update({
                                        "exitisapproved": "ExitApproved",
                                        "exitdatetime": DateTime.now(),
                                        "entryisapproved": null,
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
                                        "exitisapproved": null
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
              //             tance
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
