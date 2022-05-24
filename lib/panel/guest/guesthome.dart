import 'package:college_gate/panel/guest/appointment.dart';
import 'package:college_gate/panel/guest/facapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GuestHome extends StatelessWidget {
  const GuestHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0Xff15609c),
          title: Text(
            "Book Appointment",
            style: TextStyle(fontSize: heightMobile * 0.025),
          ),
        ),
        body: Container(
          height: heightMobile,
          width: widthMobile,
          padding: EdgeInsets.all(heightMobile * 0.02),
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
                  elevation: 4,
                  child: Column(
                    children: [
                      SizedBox(
                        height: heightMobile * 0.2,
                        child: Ink.image(
                          image: AssetImage("assets/studentAppointment.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            heightMobile * 0.02,
                            heightMobile * 0.01,
                            heightMobile * 0.015,
                            heightMobile * 0.01),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Student",
                              style: TextStyle(
                                  fontSize: heightMobile * 0.021,
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
                                  size: heightMobile * 0.03,
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => facbooking()));
                },
                child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      SizedBox(
                        height: heightMobile * 0.2,
                        child: Ink.image(
                          image: AssetImage("assets/facultyAppointment.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            heightMobile * 0.02,
                            heightMobile * 0.01,
                            heightMobile * 0.015,
                            heightMobile * 0.01),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Faculty",
                              style: TextStyle(
                                  fontSize: heightMobile * 0.021,
                                  color: Color(0Xff232F77)),
                            ),
                            //SizedBox(width: widthMobile * 0.1,),
                            IconButton(
                                alignment: Alignment.centerRight,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => facbooking()));
                                },
                                icon: Icon(
                                  Icons.chevron_right,
                                  size: heightMobile * 0.03,
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
