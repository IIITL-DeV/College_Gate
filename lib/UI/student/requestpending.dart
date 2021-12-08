import 'package:flutter/material.dart';

class requestpending extends StatefulWidget {
  const requestpending({Key? key}) : super(key: key);

  @override
  _requestpendingState createState() => _requestpendingState();
}

class _requestpendingState extends State<requestpending> {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Your request is Pending...",
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0Xff14619C),
                        )),
                  )
                ],
              ),
              Expanded(
                child: Image.asset(
                  'assets/requestpending.png',
                  fit: BoxFit.fitWidth,
                  width: 320.0,
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
