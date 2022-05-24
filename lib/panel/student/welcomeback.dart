import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/student/notices.dart';
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
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: heightMobile * 0.028,
                child: Image.asset("assets/cg_white.png")),
            SizedBox(
              width: 10,
            ),
            Text("College Gate",
                style: TextStyle(fontSize: heightMobile * 0.028)),
          ],
        ),
      ),
      body: SizedBox(
          width: widthMobile,
          height: heightMobile,
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: heightMobile * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.all(heightMobile * 0.025),
                    child: Text("Welcome back !!",
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
                  'assets/welcome.png',
                  fit: BoxFit.fitWidth,
                  width: widthMobile * 0.82,
                  alignment: Alignment.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(heightMobile * 0.017),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(widthMobile, heightMobile * 0.028),
                      alignment: Alignment.center,
                      primary: Color(0xFF14619C)),
                  onPressed: () => {
                    FirebaseFirestore.instance
                        .collection('studentUser')
                        .doc((FirebaseAuth.instance.currentUser!).email)
                        .update(
                      {'exitisapproved': null, 'entryisapproved': null},
                    )
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: heightMobile * 0.02,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
