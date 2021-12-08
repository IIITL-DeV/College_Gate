import 'package:college_gate/UI/warden/viewimage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class noNotices extends StatefulWidget {
  const noNotices({Key? key}) : super(key: key);

  @override
  _noNoticesState createState() => _noNoticesState();
}

class _noNoticesState extends State<noNotices> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("studentGuest")
        .doc((FirebaseAuth.instance.currentUser!).email)
        .collection("guestUser")
        .where("gentryisapproved", isEqualTo: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
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
                    Text("No Notices",
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
                      height: 120,
                      child: ListView(
                        children: [
                          ListTile(
                            onTap: () {}, //Zoom Image Function
                            //name
                            title: Text(
                              "${chatItem["guestname"]}",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "wants to meets you on ${chatItem["guestentrytime"]}, ${chatItem["guestentrydate"]}"),
                          ),

                          //Accept, Decline button
                          Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40.0,
                                width: 173.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("studentGuest")
                                        .doc(
                                            (FirebaseAuth.instance.currentUser!)
                                                .email)
                                        .collection("guestUser")
                                        .doc(chatItem["guestphone"])
                                        .collection("gentryisapproved")
                                    .doc()
                                        .update({
                                      "gentryisapproved": true
                                    }).then((_) {
                                      print("success!");
                                    });
                                    FirebaseFirestore.instance
                                        .collection("studentGuest")
                                        .doc(
                                            (FirebaseAuth.instance.currentUser!)
                                                .email)
                                        .collection("guestUser")
                                        .doc(chatItem["guestphone"])
                                      
                                        .update({
                                      "gentryisapproved": true
                                    }).then((_) {
                                      print("success!");
                                    });
                                  },
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(
                                      fontSize: 16.0,
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
                                width: 16.0,
                              ),
                              Container(
                                height: 40.0,
                                width: 173.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("studentGuest")
                                        .doc(
                                            (FirebaseAuth.instance.currentUser!)
                                                .email)
                                        .collection("guestUser")
                                        .doc(chatItem["guestphone"])
                                        .collection("gentryisapproved")
                                    .doc()
                                        .update({
                                      "gentryisapproved": null
                                    }).then((_) {
                                      print("success!");
                                    });
                                    FirebaseFirestore.instance
                                        .collection("studentGuest")
                                        .doc(
                                            (FirebaseAuth.instance.currentUser!)
                                                .email)
                                        .collection("guestUser")
                                        .doc(chatItem["guestphone"])
                                      
                                        .update({
                                      "gentryisapproved": null
                                    }).then((_) {
                                      print("success!");
                                    });
                                  },
                                  child: Text(
                                    "Decline",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
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
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }
}
