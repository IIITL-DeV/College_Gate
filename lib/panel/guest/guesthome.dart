import 'package:college_gate/panel/faculty/facultyList.dart';
import 'package:college_gate/panel/faculty/facultyProfile.dart';
import 'package:college_gate/panel/guest/student_appointment.dart';
import 'package:college_gate/panel/guest/faculty_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class GuestHome extends StatelessWidget {
  const GuestHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0Xff15609c),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 21.sp, child: Image.asset("assets/cg_white.png")),
              SizedBox(
                width: 12.w,
              ),
              Text("Book Appointment", style: TextStyle(fontSize: 20.sp)),
              //SizedBox(width: 50.w,),
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 13.h),
          child: Column(
            children: [
              // Container(
              //   padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              //   child: Text("Book Appointment",
              //       style: TextStyle(
              //         fontSize: 24.0,
              //         fontWeight: FontWeight.bold,
              //         letterSpacing: 1.0,
              //         color: Color(0Xff15609c),
              //       )),
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => booking()));
                },
                child: Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 138.h,
                        child: Ink.image(
                          image: AssetImage("assets/studentAppointment.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.w, 8.h, 5.w, 8.h),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Student",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0Xff232F77)),
                            ),
                            //SizedBox(width: widthMobile * 0.1,),
                            IconButton(
                                alignment: Alignment.centerRight,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => booking()));
                                },
                                icon: Icon(
                                  Icons.chevron_right,
                                  size: 23.sp,
                                  color: Color(0Xff232F77),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FacultyList(
                                isStudent: false,
                              )));
                },
                child: Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 138.h,
                        child: Ink.image(
                          image: AssetImage("assets/facultyAppointment.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.w, 8.h, 5.w, 8.h),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Faculty",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0Xff232F77)),
                            ),
                            //SizedBox(width: widthMobile * 0.1,),
                            IconButton(
                                alignment: Alignment.centerRight,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FacultyList(
                                                isStudent: false,
                                              )));
                                },
                                icon: Icon(
                                  Icons.chevron_right,
                                  size: 23.sp,
                                  color: Color(0Xff232F77),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
