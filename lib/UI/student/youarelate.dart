import 'package:flutter/material.dart';

class youarelate extends StatefulWidget {
  const youarelate({ Key? key }) : super(key: key);

  @override
  _youarelateState createState() => _youarelateState();
}

class _youarelateState extends State<youarelate> {
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
                    child: Text("You are late !!",
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
                  'assets/youarelate.png',
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
            ],
          )),
    );
  }
}