import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/sign_in.dart';
import 'package:college_gate/UI/student/exit_screen.dart';
import 'package:college_gate/UI/student/homepagecard.dart';
import 'package:college_gate/UI/student/idcardImage.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class completeProfile extends StatefulWidget {
  @override
  _completeProfileState createState() => _completeProfileState();
}

class _completeProfileState extends State<completeProfile> {
  String? _username, _enrollmentNo, _email, _roomno, _phoneno;

  Future<void> _getUserDetails() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc(await (FirebaseAuth.instance.currentUser)!.email)
        .get()
        .then((value) {
      setState(() {
        _username = value.data()!['name'].toString();
        _enrollmentNo = value.data()!['enrollment'].toString();
        _email = value.data()!['email'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getUserDetails();
  }

  String? dropdownValue,hostelDropDown;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    if (_username == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0Xff15609c),
          title: Text("College Gate",
              style: TextStyle(fontSize: heightMobile * 0.025)),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: heightMobile * 0.02,
                  horizontal: widthMobile * 0.07),
              child: Form(
                  key: _formKey,
                  child: Center(
                      child: Column(
                    children: [
                      SizedBox(height: heightMobile * 0.02),
                      SizedBox(
                        height: heightMobile * 0.13,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1500),
                          child: Image.asset(
                            "assets/iiitl.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: heightMobile * 0.02),
                      TextFormField(
                          decoration: const InputDecoration(labelText: 'Name'),
                          initialValue: _username,
                          style: TextStyle(
                            fontSize: heightMobile * 0.02,
                          ),
                          readOnly: true,
                          onSaved: (value) => _username = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name is Required";
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: heightMobile * 0.009),
                      TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Enrollnment Number'),
                          initialValue: _enrollmentNo,
                          style: TextStyle(
                            fontSize: heightMobile * 0.02,
                          ),
                          readOnly: true,
                          onSaved: (value) => _enrollmentNo = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enrollnment number is Required";
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: heightMobile * 0.009),
                      TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          initialValue: _email,
                          style: TextStyle(
                            fontSize: heightMobile * 0.02,
                          ),
                          readOnly: true,
                          onSaved: (value) => _email = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is Required";
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: heightMobile * 0.009),
                      TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onSaved: (value) => _phoneno = value,
                          style: TextStyle(
                            fontSize: heightMobile * 0.02,
                          ),
                          decoration:
                              const InputDecoration(labelText: 'Phone Number'),
                          validator: (value) {
                            if (value!.length == 10 && value != null) {
                              _phoneno = value;
                            } else {
                              return "Valid phone number is required";
                            }
                          }),
                      SizedBox(height: heightMobile * 0.009),
                      TextFormField(
                          onSaved: (value) => _roomno = value,

                          //controller: ,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: TextStyle(
                            fontSize: heightMobile * 0.02,
                          ),
                          decoration:
                              const InputDecoration(labelText: 'Room Number'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Room number is required";
                            } else {
                              _roomno = value;
                            }
                          }),
                      SizedBox(height: heightMobile * 0.02),
                      Container(
                        height: heightMobile * 0.065,
                        width: widthMobile * 0.9,
                        margin: EdgeInsets.all(0),
                        child: DropdownButtonHideUnderline(
                          child: GFDropdown(
                            padding: const EdgeInsets.all(15),
                            borderRadius: BorderRadius.circular(5),
                            border: const BorderSide(
                                color: Colors.black12, width: 1),
                            dropdownButtonColor: Colors.white,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: heightMobile * 0.02,
                            ),
                            value: hostelDropDown,
                            onChanged: (newValue) {
                              setState(() {
                                hostelDropDown = newValue as String?;
                              });
                            },
                            hint: Text(
                              "Hostel",
                            ),
                            items: ['Hostel 1', 'Hostel 2']
                                .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                                .toList(),
                          ),
                        ),
                      ),
                      // SizedBox(height: heightMobile * 0.02),
                      //
                      // Container(
                      //   height: heightMobile * 0.065,
                      //   width: widthMobile * 0.9,
                      //   margin: EdgeInsets.all(0),
                      //   child: DropdownButtonHideUnderline(
                      //     child: GFDropdown(
                      //       padding: const EdgeInsets.all(15),
                      //       borderRadius: BorderRadius.circular(5),
                      //       border: const BorderSide(
                      //           color: Colors.black12, width: 1),
                      //       dropdownButtonColor: Colors.white,
                      //       style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: heightMobile * 0.02,
                      //       ),
                      //       value: dropdownValue,
                      //       onChanged: (newValue) {
                      //         setState(() {
                      //           dropdownValue = newValue as String?;
                      //         });
                      //       },
                      //       hint: Text(
                      //         "Sign in as",
                      //       ),
                      //       items: ['Student', 'Faculty']
                      //           .map((value) => DropdownMenuItem(
                      //                 value: value,
                      //                 child: Text(value),
                      //               ))
                      //           .toList(),
                      //     ),
                      //   ),
                      // ),

                      SizedBox(height: heightMobile * 0.07),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                              primary: Color(0Xff15609c),
                              padding: EdgeInsets.all(heightMobile * 0.017),
                              // padding: const EdgeInsets.all(10),
                              minimumSize:
                                  Size(widthMobile, heightMobile * 0.028)),
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: heightMobile * 0.022,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );

                              await FirebaseFirestore.instance
                                  .collection('studentUser')
                                  .doc((await FirebaseAuth
                                      .instance.currentUser!.email))
                                  .update(
                                {
                                  'signinas': dropdownValue,
                                  'phone': _phoneno,
                                  'room': _roomno
                                },
                              );
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => idcardImage()));
                            } else {
                              print("Not validated");
                            }
                          })
                    ],
                  )))),
        ));
  }
}
