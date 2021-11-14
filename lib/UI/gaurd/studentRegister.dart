import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';

class studentRegister extends StatefulWidget {
  const studentRegister({Key? key}) : super(key: key);

  @override
  _studentRegisterState createState() => _studentRegisterState();
}

class _studentRegisterState extends State<studentRegister> {
  @override
  Widget build(BuildContext context) {
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
          stream: FirebaseFirestore.instance
              .collection("studentRegister")
              //  .where("exitisapproved", isEqualTo: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
