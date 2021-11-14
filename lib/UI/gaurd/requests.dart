import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class guard_requests extends StatefulWidget {
  // const guard_requests({Key? key}) : super(key: key);

  @override
  _guard_requestsState createState() => _guard_requestsState();
}

class _guard_requestsState extends State<guard_requests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("studentUser")
          .where("exitisapproved", isEqualTo: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: Text(
              "No Requests",
              style: TextStyle(
                color: Color(0Xff15609c),
              ),
            ),
          );
        return ListView.builder(
            itemBuilder: (context, index) {
              final chatItem = snapshot.data!.docs[index];
              return ListTile(
                leading: Text(
                  chatItem["name"] ?? '',
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                subtitle: Column(
                  children: <Widget>[
                    ElevatedButton(
                        child: Text('Accept'),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("studentUser")
                              .doc(chatItem["userid"])
                              .update({"exitisapproved": true}).then((_) {
                            print("success!");
                          });
                        })
                  ],
                ),

                // title: Text(chatItem[""] ?? '',
                //     style: TextStyle(
                //         fontSize: 20,
                //         color: chatItem['user_name'] == 'Trump'
                //             ? Colors.pink
                //             : Colors.blue)),
              );
            },
            itemCount: snapshot.data!.docs.length);
      },
    ));
  }
}
