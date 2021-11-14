import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class gaurdlog extends StatefulWidget {
  // const guard_profile({Key? key}) : super(key: key);

  @override
  _gaurdlogState createState() => _gaurdlogState();
}

class _gaurdlogState extends State<gaurdlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("studentUser")
          .where("exitisapproved", isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        return ListView.builder(
            itemBuilder: (context, index) {
              final chatItem = snapshot.data!.docs[index];
              return ListTile(
                leading: Text(
                  chatItem["name"] ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
