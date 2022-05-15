import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/sign_in.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';

class w_studentRegister extends StatefulWidget {
  const w_studentRegister({Key? key}) : super(key: key);

  @override
  _w_studentRegisterState createState() => _w_studentRegisterState();
}

class _w_studentRegisterState extends State<w_studentRegister> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("studentRegister")
        //      .where("exitisapproved", isEqualTo: false)
        .where("purpose", isEqualTo: "Home")
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
                        Text("No Requests",
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
                                  "${chatItem["name"]}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text("${chatItem["enrollment"]}"),
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
                                    "Room ${chatItem["room"]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  //SizedBox(height: 5),
                                  Text(
                                    "${chatItem["exittime"]} | ${chatItem["exitdate"]}",
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
                                    "${chatItem["entrytime"]} | ${chatItem["entrydate"]}",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      backgroundColor: Color(0XffD1F0E8),
                                    ),
                                  )
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
