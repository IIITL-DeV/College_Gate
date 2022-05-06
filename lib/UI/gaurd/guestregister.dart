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
        .doc()
        .collection("guestUser")
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
            backgroundColor: Color(0Xff15609c),
            title: Text("College Gate"),
            actions: [
              InkWell(
                onTap: () {
                  AuthMethods().logout().then((s) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.deepPurple[50],
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
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 200),
                        Image.asset(
                          'assets/nonotices.png',
                          //fit: BoxFit.fitWidth,
                          width: 280.0,
                          height: 280,
                          alignment: Alignment.center,
                        ),
                        Text("No Entry",
                            style: TextStyle(
                              fontSize: 30.0,
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
                    padding: const EdgeInsets.all(3.0),
                    child: Card(
                      elevation: 3.5,
                      child: Expanded(
                        child: SizedBox(
                          height: 110,
                          child: ListView(
                            children: [
                              ListTile(
                                title: Text(
                                  "${chatItem["guestname"]}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text("${chatItem["guestphone"]}"),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "Student     ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  //SizedBox(height: 5),
                                  Text(
                                    "4:05 AM | 04-12-2021",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      backgroundColor: Color(0XffD1F0E8),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color(0XffD1F0E8),
                                    size: 11,
                                  ),

                                  Text(
                                    "${chatItem["guestentrytime"]} | ${chatItem["guestentrydate"]}",
                                    style: TextStyle(
                                      fontSize: 12.0,
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
