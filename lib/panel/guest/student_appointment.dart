import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/main.dart';

import 'package:college_gate/panel/student/requestpending.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class booking extends StatefulWidget {
  const booking({Key? key}) : super(key: key);

  @override
  _bookingState createState() => _bookingState();
}

class _bookingState extends State<booking> {
  final _formKey = GlobalKey<FormState>();
  var v;
  String? ans;
  String? email, name, genrollnment, gexitdate, gexittime;
  @override
  void initState() {
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute), [
      hh,
      ':',
      nn,
    ]).toString();
    super.initState();
  }

  late String _hour, _minute, _time;

  // late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Widget _buildDate() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _dateController,
          decoration: InputDecoration(
            labelText: 'Date',
            // : Colors.white70,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: Colors.black12,
                width: 1,
              ),
            ),
          ),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              initialDatePickerMode: DatePickerMode.day,
              firstDate: DateTime(2021),
              lastDate: DateTime(2101),
              builder: (context, child) => Theme(
                data: ThemeData().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Color(0Xff19B38D), //Color(0Xff15609c)
                    onSurface: Color(0Xff15609c),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child!,
              ),
            );
            if (picked != null)
              setState(() {
                selectedDate = picked;
                _dateController.text =
                    DateFormat('dd-MM-yyyy').format(selectedDate);
              });
          },
        )),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: TextField(
          controller: _timeController,
          decoration: InputDecoration(
            labelText: 'Time',
            // : Colors.white70,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: Colors.black12,
                width: 1,
              ),
            ),
          ),
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: selectedTime,
              builder: (context, child) => Theme(
                data: ThemeData().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Color(0Xff19B38D), //Color(0Xff15609c)
                    onSurface: Color(0Xff15609c),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child!,
              ),
            );
            if (picked != null)
              setState(() {
                selectedTime = picked;
                _hour = selectedTime.hour.toString();
                _minute = selectedTime.minute.toString();
                _time = _hour + ' : ' + _minute;
                _timeController.text = _time;
                _timeController.text = formatDate(
                    DateTime(
                        2019, 08, 1, selectedTime.hour, selectedTime.minute),
                    [
                      hh,
                      ':',
                      nn,
                    ]).toString();
              });
          },
        )),
      ],
    );
  }

  Widget _buildName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Name'),
      //initialValue: _username!,
      validator: (value) {
        // value:
        if (value == null || value.isEmpty) {
          return "Name is required";
        } else {
          name = value;
          // FirebaseFirestore.instance.collection('studentGuest').doc().set({
          //   'guestname': value,
          // }, SetOptions(merge: true));
          return null;
        }
      },
    );
  }

  Widget _buildemail() {
    return TextFormField(
        //initialValue: _emailno!,
        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(labelText: 'Email ID'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email ID is required";
          } else {
            email = value;
            return null;
          }
        });
  }

  Widget _buildstudentemail() {
    return TextFormField(
        decoration:
            const InputDecoration(labelText: "Visiting Student's Email ID"),
        //initialValue: _enrollmentNo!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Visiting Student's Email ID is required";
          } else {
            genrollnment = value;
            return null;
          }
        });
  }

  Widget _buildVehicle() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Vehicle Number'));
    //initialValue: _roomno!,
    // validator: (value) {

    // });
  }

  Widget _buildRelation() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Relation/Purpose'),
        //initialValue: _roomno!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Relation/Purpose is required";
          } else {
            return null;
          }
        });
  }

  // Widget _buildTime() {
  //   DateTime times = DateTime.now();
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: TextFormField(
  //             decoration: InputDecoration(
  //               labelText: 'Date',
  //               // : Colors.white70,
  //               focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(0),
  //                 borderSide: BorderSide(
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(0),
  //                 borderSide: BorderSide(
  //                   color: Colors.black12,
  //                   width: 1,
  //                 ),
  //               ),
  //             ),
  //             initialValue: DateFormat('dd-MM-yyyy').format(times),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return "Date is required";
  //               } else {
  //                 gexitdate = value;
  //
  //                 return null;
  //               }
  //             }),
  //       ),
  //       SizedBox(
  //         width: 10,
  //       ),
  //       Expanded(
  //         child: TextFormField(
  //             decoration: InputDecoration(
  //               labelText: 'Time',
  //               // : Colors.white70,
  //               focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(0),
  //                 borderSide: BorderSide(
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(0),
  //                 borderSide: BorderSide(
  //                   color: Colors.black12,
  //                   width: 1,
  //                 ),
  //               ),
  //             ),
  //             initialValue: DateFormat('HH:mm a').format(times),
  //             // decoration: const InputDecoration(labelText: 'Time'),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return "Time is Required";
  //               } else {
  //                 gexittime = value;
  //
  //                 return null;
  //               }
  //             }),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildMessage() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      maxLength: 100,
      decoration: const InputDecoration(labelText: 'Description'),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return "Reason is Required";
      //   } else {
      //     return null;
      //   }
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xff15609c),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: heightMobile * 0.028,
            ),
            onPressed: () => {Navigator.pop(context)}),
        title: Text(
          "Student Appointment Form",
          style: TextStyle(color: Colors.white, fontSize: heightMobile * 0.025),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(heightMobile * 0.025),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildName(),
                  _buildemail(),
                  _buildstudentemail(),
                  _buildRelation(),
                  SizedBox(height: heightMobile * 0.04),
                  _buildDate(),
                  // SizedBox(height: heightMobile * 0.015),
                  // _buildVehicle(),
                  _buildMessage(),
                  SizedBox(height: heightMobile * 0.05),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                          primary: Color(0Xff15609c),
                          padding: EdgeInsets.all(heightMobile * 0.017),
                          // padding: const EdgeInsets.all(10),
                          minimumSize: Size(widthMobile, heightMobile * 0.028)),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: heightMobile * 0.02,
                        ),
                      ),
                      onPressed: () => {
                            if (_formKey.currentState!.validate())
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                ),
                                FirebaseFirestore.instance
                                    .collection('studentUser')
                                    .doc(genrollnment)
                                    .collection('guestemail')
                                    .doc(email)
                                    .set({
                                  'guestname': name,
                                  'guestemail': email,
                                  'guestappointdatetime': DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute),
                                }, SetOptions(merge: true)),

                                flutterToast("Request has been sent."),
                                Navigator.of(context).pop(),

                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => grequestpending(
                                //             genrollnment!, email!))),
                                // v = FirebaseFirestore.instance
                                //     .collection("studentUser")
                                //     .where("email", isEqualTo: email)
                                //     .get(),
                                // ans = v["userid"],
                                // print("answerissssssssssssss$ans")
                              }
                            else
                              {print("Not validated")}
                          })
                ],
              ),
            )),
      ),
    );
  }
}
