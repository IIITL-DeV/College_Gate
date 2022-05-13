import 'package:college_gate/UI/guest/appointment.dart';
import 'package:college_gate/UI/guest/facapp.dart';
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
          title: Text("Book Appointment", style: TextStyle(fontSize: heightMobile * 0.025),),
        ),
        body: Padding(
          padding: EdgeInsets.all(heightMobile * 0.003),
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
              Container(
                  padding: EdgeInsets.fromLTRB(
                      heightMobile * 0.015,
                      heightMobile * 0.01,
                      heightMobile * 0.015,
                      heightMobile * 0.01),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => booking()));
                      },
                      child: Card(
                        elevation: 4,
                        child: Column(children: [
                          SizedBox(
                            height: heightMobile * 0.2,
                            child: Ink.image(
                              image: AssetImage("assets/studentAppointment.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(heightMobile * 0.015),
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                Text("Student",style: TextStyle(fontSize: heightMobile * 0.019),),
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
                                    )),
                              ])),
                        ]),
                      ),
                    ),
                  )),
              Container(
                padding: EdgeInsets.fromLTRB(
                  heightMobile * 0.015,
                  heightMobile * 0.01,
                  heightMobile * 0.015,
                  heightMobile * 0.01),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  facbooking()));
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
                            padding: EdgeInsets.all(heightMobile * 0.015),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text("Faculty",style: TextStyle(fontSize: heightMobile * 0.019),),
                                IconButton(
                                    alignment: Alignment.centerRight,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  facbooking()));
                                    },
                                    icon: Icon(
                                      Icons.chevron_right,
                                      size: heightMobile * 0.03,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
