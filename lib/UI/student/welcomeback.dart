import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/student/notices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class welcomeback extends StatefulWidget {
  const welcomeback({Key? key}) : super(key: key);

  @override
  _welcomebackState createState() => _welcomebackState();
}

class _welcomebackState extends State<welcomeback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Welcome back !!",
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0Xff14619C),
                        )),
                  )
                ],
              ),
              Expanded(
                child: Image.asset(
                  'assets/welcome.png',
                  fit: BoxFit.fitWidth,
                  width: 350.0,
                  alignment: Alignment.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(400, 50),
                      alignment: Alignment.center,
                      primary: const Color(0xFF14619C)),
                  onPressed: () => {
                    FirebaseFirestore.instance
                        .collection('studentUser')
                        .doc((FirebaseAuth.instance.currentUser!).uid)
                        .update(
                      {'entryisapproved': null},
                    )
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
