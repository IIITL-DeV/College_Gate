import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class requestpending extends StatefulWidget {
  const requestpending({Key? key}) : super(key: key);

  @override
  _requestpendingState createState() => _requestpendingState();
}

class _requestpendingState extends State<requestpending> {
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
                    child: Text("Your request is pending...",
                        style: TextStyle(
                          fontSize: 30.sp,
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
                  width: MediaQuery.of(context).size.width * 0.82,
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
