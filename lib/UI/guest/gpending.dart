import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/guest/appointment.dart';
import 'package:college_gate/UI/guest/guesthome.dart';
import 'package:college_gate/UI/student/readytogo.dart';
import 'package:college_gate/UI/student/welcomeback.dart';
import 'package:flutter/material.dart';

class grequestpending extends StatefulWidget {
  String genrollnment, phone;
  grequestpending(this.genrollnment, this.phone);

  @override
  _grequestpendingState createState() => _grequestpendingState();
}

class _grequestpendingState extends State<grequestpending> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("studentGuest")
        .doc(widget.genrollnment)
        .collection("guestUser")
        .doc(widget.phone)
        .collection("gentryisapproved")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('College Gate'),
          backgroundColor: Color(0Xff15609c),
        ),
        body: StreamBuilder(
          stream: stream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final chatItem = snapshot.data!.docs[index];
                  print("issssssssssssssssssss${chatItem["gentryisapproved"]}");
                  if (chatItem["gentryisapproved"] == false) {
                    print(
                        "issssssssssssssssssss${chatItem["gentryisapproved"]}");
                    return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text("Your request is Pending...",
                                      style: TextStyle(
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0Xff14619C),
                                      )),
                                )
                              ],
                            ),
                            Expanded(
                              child: Image.asset(
                                'assets/requestpending.png',
                                fit: BoxFit.fitWidth,
                                width: 320.0,
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ));
                  }
                  if (chatItem["gentryisapproved"] == true)
                    return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text("Ready to go !!",
                                      style: TextStyle(
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0Xff14619C),
                                      )),
                                )
                              ],
                            ),
                            Expanded(
                              child: Image.asset(
                                'assets/readytogo.png',
                                fit: BoxFit.fitWidth,
                                width: 320.0,
                                alignment: Alignment.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  alignment: Alignment.center,
                                  primary: const Color(0xFF14619C)),
                              onPressed: () => {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GuestHome())),
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ));
                  return SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                    "Request Declined! Try booking appointment later.",
                                    style: TextStyle(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0Xff14619C),
                                    )),
                              )
                            ],
                          ),
                          Expanded(
                            child: Image.asset(
                              'assets/youarelate.png',
                              fit: BoxFit.fitWidth,
                              width: 320.0,
                              alignment: Alignment.center,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                alignment: Alignment.center,
                                primary: const Color(0xFF14619C)),
                            onPressed: () => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GuestHome())),
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ));
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
