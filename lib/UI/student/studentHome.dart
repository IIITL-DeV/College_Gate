import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';

class studentHome extends StatefulWidget {
  const studentHome({Key? key}) : super(key: key);

  @override
  _studentHomeState createState() => _studentHomeState();
}

class _studentHomeState extends State<studentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo[900],
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
      body: Center(
          child: Text(
        "Welcome!",
        style: TextStyle(fontSize: 50),
      )),
    );
  }
}
