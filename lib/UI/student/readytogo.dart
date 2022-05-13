import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/student/notices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReadytoGo extends StatefulWidget {
  const ReadytoGo({Key? key}) : super(key: key);

  @override
  _ReadytoGoState createState() => _ReadytoGoState();
}

class _ReadytoGoState extends State<ReadytoGo> {
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
          width: widthMobile,
          height: heightMobile,
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                  SizedBox(
                    height: heightMobile * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.all(heightMobile * 0.025),
                    child: Text("Ready to go !!",
                        style: TextStyle(
                          fontSize: heightMobile * 0.042,
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
                  width: widthMobile * 0.82,
                  alignment: Alignment.center,
                ),
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       minimumSize: const Size(double.infinity, 50),
              //       alignment: Alignment.center,
              //       primary: const Color(0xFF14619C)),
              //   onPressed: () => {},
              //   child: const Text(
              //     'Submit',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //         minimumSize: const Size(400, 50),
              //         alignment: Alignment.center,
              //         primary: const Color(0xFF14619C)),
              //     onPressed: () => {
              //       FirebaseFirestore.instance
              //       //     .collection('studentUser')
              //       //     .doc((FirebaseAuth.instance.currentUser!).uid)
              //       //     .update(
              //       //   {'exitisapproved': null},
              //       // )
              //     },
              //     child: const Text(
              //       'Done',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          )),
    );
  }
}
