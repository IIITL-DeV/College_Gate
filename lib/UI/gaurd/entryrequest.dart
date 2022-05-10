import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:college_gate/UI/warden/viewimage.dart';

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
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
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
                  child: Expanded(
                    child: SizedBox(
                      height: heightMobile * 0.19,
                      width: widthMobile * 0.9,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text(
                              "${chatItem["name"]}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: heightMobile * 0.025, fontWeight: FontWeight.bold),
                            ),

                            //Phone number and Time
                            subtitle: Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: heightMobile * 0.01,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_call,
                                          size: heightMobile * 0.014,
                                        ),
                                        SizedBox(
                                          width: widthMobile * 0.02,
                                        ),
                                        Text("${chatItem["phone"]}", style: TextStyle(fontSize: heightMobile * 0.017),),
                                      ],
                                    ),
                                    SizedBox(
                                      height: heightMobile * 0.005,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_alarm,
                                          size: heightMobile * 0.015,
                                        ),
                                        SizedBox(
                                          width: widthMobile * 0.02,
                                        ),
                                        Text(
                                          "${chatItem["time"]} | ${chatItem["date"]}",
                                          style: TextStyle(
                                            fontSize: heightMobile * 0.017,
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
                                minWidth: widthMobile * 0.01,
                                minHeight: heightMobile * 0.01,
                                maxWidth: widthMobile * 0.15,
                                maxHeight: heightMobile * 0.15,
                              ),
                              child: GestureDetector(
                                  child: Hero(
                                    tag: chatItem["idcard"]!,
                                    child: Image.network(
                                        "${chatItem["idcard"]}",
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
                                SizedBox(height: heightMobile * 0.025),
                                Text("${chatItem["room"]}", style: TextStyle(fontSize: heightMobile * 0.017, fontWeight: FontWeight.bold),),
                                SizedBox(height: heightMobile * 0.004),
                                Text("${chatItem["enrollment"]}",style: TextStyle(fontSize: heightMobile * 0.017, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            contentPadding:
                            EdgeInsets.fromLTRB(heightMobile * 0.017, heightMobile * 0.017,heightMobile * 0.017,heightMobile * 0.003),
                          ),
                          SizedBox(
                            height: heightMobile * 0.01,
                          ),
                          //Accept, Decline button
                          Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: heightMobile * 0.05,
                                    width: widthMobile * 0.42,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("studentUser")
                                            .doc(chatItem["userid"])
                                            .update({"entryisapproved": true}).then(
                                                (_) {
                                              print("success!");
                                            });
                                      },
                                      child: Text(
                                        "Accept",
                                        style: TextStyle(
                                          fontSize: heightMobile * 0.02,
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
                                    height: heightMobile * 0.05,
                                    width: widthMobile * 0.42,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("studentUser")
                                            .doc(chatItem["userid"])
                                            .update({"entryisapproved": null}).then(
                                                (_) {
                                              print("success!");
                                            });
                                      },
                                      child: Text(
                                        "Decline",
                                        style: TextStyle(
                                          fontSize: heightMobile * 0.02,
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








