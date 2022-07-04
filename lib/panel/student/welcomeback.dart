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
                    child: Text("Welcome!",
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
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       minimumSize: Size(widthMobile, heightMobile * 0.055),
                //       alignment: Alignment.center,
                //       primary: Color(0xFF14619C)),
                //   onPressed: () => {
                //     FirebaseFirestore.instance
                //     //     .collection('studentUser')
                //     //     .doc((FirebaseAuth.instance.currentUser!).email)
                //     //     .update(
                //     //   {'entryisapproved': null},
                //     // ).then((value) => setState(
                //     //           () {},
                //     //         ))
                //   },
                //   child: Text(
                //     'Done',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: heightMobile * 0.02,
                //     ),
                //   ),
                // ),
              ),
            ],
          )),
    );
  }
}
