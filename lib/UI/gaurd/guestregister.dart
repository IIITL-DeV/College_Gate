import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        .collection("studentGuest")
        //      .where("exitisapproved", isEqualTo: false)
        //.where("purpose", isEqualTo: "Outing")
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
        appBar: AppBar(
            backgroundColor: Color(0Xff15609c),
            title: Text("College Gate",style: TextStyle(fontSize: heightMobile * 0.025),),
            actions: [
              InkWell(
                onTap: () {
                  AuthMethods().logout().then((s) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: heightMobile * 0.024),
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.deepPurple[50],
                      size: heightMobile * 0.027,
                    )),
              )
            ]),
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
                        Text("No Entry",
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
                          height: heightMobile * 0.1,
                          child: ListView(
                            children: [
                              ListTile(
                                title: Text(
                                  "${chatItem["guestname"]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: heightMobile * 0.021, fontWeight: FontWeight.bold),
                                ),
                                trailing: Text("${chatItem["guestphone"]}", style: TextStyle(fontSize: heightMobile * 0.017,)),
                                contentPadding:
                                EdgeInsets.fromLTRB(heightMobile * 0.017, heightMobile * 0.001,heightMobile * 0.017,heightMobile * 0.00),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: widthMobile * 0.001,
                                  ),
                                  Text(
                                    "Student     ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: heightMobile * 0.017,
                                    ),
                                  ),
                                  //SizedBox(height: 5),
                                  Text(
                                    "4:05 AM | 04-12-2021",
                                    style: TextStyle(
                                      fontSize: heightMobile * 0.0155,
                                      backgroundColor: Color(0XffD1F0E8),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color(0XffD1F0E8),
                                    size: heightMobile * 0.015,
                                  ),

                                  Text(
                                    "${chatItem["guestentrytime"]} | ${chatItem["guestentrydate"]}",
                                    style: TextStyle(
                                      fontSize: heightMobile * 0.0155,
                                      backgroundColor: Color(0XffD1F0E8),
                                    ),
                                  ),
                                ],
                              )
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
