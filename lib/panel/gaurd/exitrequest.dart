import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/gaurd/entryrequest.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/panel/warden/viewimage.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          // give the tab bar a height [can change hheight to preferred height]
          Container(
            height: heightMobile * 0.073,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                25.0,
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
        .where("exitisapproved", isEqualTo: false)
        .where("purpose", isEqualTo: "Outing")
        // .orderBy("exitisapproved")
        // .orderBy("purpose")
        // .orderBy("exitdatetime", descending: true)
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
                                    "${chatItem["time"]} | ${chatItem["date"]}",
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
                                "${chatItem["room"]}",
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
                              cardheight * 0.05),
                        ),
                        SizedBox(
                          height: cardheight * 0.03,
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
                                        "exitisapproved": true
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
                                        "exitisapproved": null
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
