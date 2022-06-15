import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 150.h),
            child: Column(
              children: <Widget>[
                //SizedBox(height: 266.h),
                Image.asset(
                  'assets/nonotices.png',
                  //fit: BoxFit.fitWidth,
                  width: 228.w,
                  height: 228.h,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text("No Notices",
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w300,
                      color: Color(0Xff14619C),
                    )),
              ],
            ),
          ))
    );
  }
}
