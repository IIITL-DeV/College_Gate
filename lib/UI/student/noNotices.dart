import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class noNotices extends StatefulWidget {
  const noNotices({Key? key}) : super(key: key);

  @override
  _noNoticesState createState() => _noNoticesState();
}

class _noNoticesState extends State<noNotices> {
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
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No Notices",
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w300,
                          color: Color(0XFF3F3D56),
                        )),
                  )
                ],
              ),
              Expanded(
                child: Image.asset(
                  'assets/readytogo.png',
                  fit: BoxFit.fitWidth,
                  width: 220.0,
                  alignment: Alignment.center,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    alignment: Alignment.center,
                    primary: const Color(0xFF14619C)),
                onPressed: () => {},
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
