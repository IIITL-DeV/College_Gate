import 'package:flutter/material.dart';

class youarelate extends StatefulWidget {
  const youarelate({ Key? key }) : super(key: key);

  @override
  _youarelateState createState() => _youarelateState();
}

class _youarelateState extends State<youarelate> {
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
                    child: Text("You are late !!",
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
                  'assets/youarelate.png',
                  fit: BoxFit.fitWidth,
                  width: 350.0,
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