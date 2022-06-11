import 'package:flutter/material.dart';

class no_notices extends StatefulWidget {
  const no_notices({Key? key}) : super(key: key);

  @override
  State<no_notices> createState() => _no_noticesState();
}

class _no_noticesState extends State<no_notices> {
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
          width: widthMobile,
          height: heightMobile,
          child: Padding(
            padding: EdgeInsets.all(heightMobile * 0.025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/nonotices.png',
                  fit: BoxFit.fitWidth,
                  width: widthMobile * 0.5,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("No Notices",
                    style: TextStyle(
                      fontSize: heightMobile * 0.042,
                      fontWeight: FontWeight.w400,
                      color: Color(0Xff14619C),
                    )),
              ],
            ),
          )),
    );
  }
}
