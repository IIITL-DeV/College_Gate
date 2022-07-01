import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class studentfacultyappointment extends StatefulWidget {
  String email;
  String token;

  studentfacultyappointment(
      {Key? key, required this.token, required this.email})
      : super(key: key);

  @override
  State<studentfacultyappointment> createState() =>
      _studentfacultyappointmentState();
}

class _studentfacultyappointmentState extends State<studentfacultyappointment> {
  final _formKey = GlobalKey<FormState>();

  late String _hour, _minute, _time;

  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  // var v;

  String? sphone, sname, semail, sappointdate, sappointtime, spurpose;

  Future<void> getUserDetails() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((FirebaseAuth.instance.currentUser)!.email)
        .get()
        .then((value) {
      setState(() {
        sname = value.data()!['name'].toString();
        print(sname);
        sphone = value.data()!['phone'].toString();
        semail = value.data()!['email'].toString();
      });
    });
  }

  @override
  void initState() {
    _dateController.text = DateFormat("dd-MM-yyyy").format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn]).toString();

    super.initState();
    getUserDetails();
  }

  Widget _buildDate() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          readOnly: true,
          style: TextStyle(fontSize: 14.sp),
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
              firstDate: DateTime.now(),
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
          width: 10.w,
        ),
        Expanded(
            child: TextField(
          style: TextStyle(fontSize: 14.sp),
          readOnly: true,
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

  Widget _buildfacultyemail() {
    return TextFormField(
        decoration: const InputDecoration(
          labelText: "Visiting Faculty's Email ID",
        ),
        style: TextStyle(fontSize: 14.sp),
        readOnly: true,
        initialValue: "${widget.email}",
        validator: (email) {
          if (email == null || email.isEmpty) {
            return "Visiting Faculty's Email ID is required";
          } else {
            // genrollnment = email;
            return null;
          }
        });
  }

  Widget _buildName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Name'),
      initialValue: sname,
      readOnly: true,
      style: TextStyle(fontSize: 14.sp),
      // validator: (value) {
      //   // value:
      //   if (value == null || value.isEmpty) {
      //     return "Name is required";
      //   } else {
      //     sname = value;
      //     return null;
      //   }
      // },
    );
  }

  Widget _buildemail() {
    return TextFormField(
      // initialValue: _phoneno!,
      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(labelText: 'Email ID'),
      initialValue: semail,
      readOnly: true,
      style: TextStyle(fontSize: 14.sp),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return "Your email ID is required";
      //   } else {
      //     guestemail = value;
      //     return null;
      //   }
      // }
    );
  }

  Widget _buildphone() {
    return TextFormField(
      initialValue: sphone,
      decoration: const InputDecoration(
        labelText: "Phone Number",
      ),
      readOnly: true,
      style: TextStyle(fontSize: 14.sp),
      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      // validator: (value) {
      //   if (value == null || value.length != 10) {
      //     return "Valid phone number is required";
      //   } else {
      //     phone = value;
      //     return null;
      //   }
      // });
    );
  }

  // Widget _buildVehicle() {
  //   return TextFormField(
  //       decoration: const InputDecoration(labelText: 'Vehicle Number'),
  //       validator: (value) {
  //         {
  //           gvehicleno = value;
  //           return null;
  //         }
  //       });
  // }

  Widget _buildRelation() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Purpose'),
        style: TextStyle(fontSize: 14.sp),
        //initialValue: _roomno!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Purpose is required";
          } else {
            spurpose = value;
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
  //                 sappointdate = value;
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
  //             initialValue: DateFormat('HH:mm').format(times),
  //             // decoration: const InputDecoration(labelText: 'Time'),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return "Time is Required";
  //               } else {
  //                 sappointtime = value;
  //
  //                 return null;
  //               }
  //             }),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildMessage() {
  //   return TextFormField(
  //       keyboardType: TextInputType.multiline,
  //       maxLines: 2,
  //       maxLength: 100,
  //       decoration: const InputDecoration(labelText: 'Description'),
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return "Reason is Required";
  //         } else {
  //           gdescription = value;
  //           return null;
  //         }
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    DateTime ans;

    if (sname == null) {
      return Center(child: CircularProgressIndicator());
    } else
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 56.h,
          backgroundColor: Color(0Xff15609c),
          centerTitle: true,
          title: Text(
            "Faculty Appointment Form",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SizedBox(height: 0.h),
                    SizedBox(
                      height: 108.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: Image.asset(
                          "assets/facultyAppointment.jpg",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _buildfacultyemail(),
                    //SizedBox(height: heightMobile * 0.02),
                    _buildName(),
                    _buildemail(),
                    _buildphone(),
                    _buildRelation(),
                    // _buildVehicle(),
                    SizedBox(height: 24.h),

                    // SizedBox(height: heightMobile * 0.015),

                    _buildDate(),
                    //  _buildMessage(),
                    SizedBox(height: 45.h),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            primary: Color(0Xff15609c),
                            padding: EdgeInsets.all(12),
                            // padding: const EdgeInsets.all(10),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 38.h)),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        onPressed: () => {
                              if (_formKey.currentState!.validate())
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  ),
                                  // ans=new DateTime(selectedDate.year, selectedDate.month,selectedDate.day,selectedTime.hour,selectedTime.minute),

                                  FirebaseFirestore.instance
                                      .collection('facultyUser')
                                      .doc(widget.email)
                                      .collection("guestemail")
                                      .doc(semail)
                                      .set({
                                    'guestname': sname,
                                    'guestphone': sphone,
                                    'guestemail': semail,
                                    // 'vistingfacultyemail': widget.email,
                                    'guestappointdatetime': DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        selectedTime.hour,
                                        selectedTime.minute),
                                    // 'guestappointtime': _timeController.text,
                                    'guestpurpose': spurpose,
                                    'isStudent': true,
                                    'appointisapproved': false,
                                  }, SetOptions(merge: true)),
                                  sendPushMessage(
                                      "You have received a new appointment request.",
                                      "Appointment Request!",
                                      widget.token),
                                  flutterToast(
                                      "Request has been sent. You will be updated further through email."),
                                  Navigator.of(context).pop(),
                                  Navigator.of(context).pop(),
                                }
                              else
                                {"invalid data"}
                            })
                  ],
                ),
              )),
        ),
      );
  }
}
