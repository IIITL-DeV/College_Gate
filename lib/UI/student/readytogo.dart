import 'package:flutter/material.dart';

class ReadytoGo extends StatefulWidget {
  const ReadytoGo({Key? key}) : super(key: key);

  @override
  _ReadytoGoState createState() => _ReadytoGoState();
}

class _ReadytoGoState extends State<ReadytoGo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF14619C),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => {}),
      ),
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
                    child: Text("Ready to go !!",
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
