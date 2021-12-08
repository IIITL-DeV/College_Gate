import 'package:college_gate/UI/guest/appointment.dart';
import 'package:college_gate/UI/guest/facapp.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GuestHome extends StatelessWidget {
  const GuestHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0Xff15609c),
          title: Text("Book Appointment"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(3.0),
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
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Card(
                      elevation: 4,
                      child: Column(children: [
                        SizedBox(
                          height: 180.0,
                          child: Ink.image(
                            image: AssetImage("assets/studentAppointment.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(12.0),
                            alignment: Alignment.centerLeft,
                            child: Row(children: [
                              Text("Student"),
                              IconButton(
                                  alignment: Alignment.centerRight,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => booking()));
                                  },
                                  icon: const Icon(Icons.chevron_right)),
                            ])),
                      ]),
                    ),
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180.0,
                          child: Ink.image(
                            image: AssetImage("assets/facultyAppointment.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text("Faculty"),
                              IconButton(
                                  alignment: Alignment.centerRight,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                facbooking()));
                                  },
                                  icon: const Icon(Icons.chevron_right))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
