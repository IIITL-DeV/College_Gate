import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/panel/student/homepagecard.dart';
import 'package:college_gate/panel/student/idcardImage.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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

  String? dropdownValue, hostelDropDown;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    if (_username == null) {
      return Center(child: CircularProgressIndicator());
    } else
      return Scaffold(
          appBar: AppBar(
            toolbarHeight: 56.h,
            backgroundColor: Color(0Xff15609c),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 21.sp, child: Image.asset("assets/cg_white.png")),
                SizedBox(
                  width: 12.w,
                ),
                Text("College Gate", style: TextStyle(fontSize: 21.sp)),
                //SizedBox(width: 50.w,),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 26.h),
                child: Form(
                    key: _formKey,
                    child: Center(
                        child: Column(
                      children: [
                        //SizedBox(height: heightMobile * 0.02),
                        SizedBox(
                          height: 100.h,
                          child: CircleAvatar(
                            radius: 52.r,
                            backgroundImage: AssetImage(
                              "assets/iiitl.png",
                              //fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            initialValue: _username,
                            style: TextStyle(
                              fontSize: 14.sp,
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
                        SizedBox(height: 6.h),
                        TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Enrollnment Number'),
                            initialValue: _enrollmentNo,
                            style: TextStyle(
                              fontSize: 14.sp,
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
                        SizedBox(height: 6.h),
                        TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            initialValue: _email,
                            style: TextStyle(
                              fontSize: 14.sp,
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
                        SizedBox(height: 6.h),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (value) => _phoneno = value,
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                            decoration: const InputDecoration(
                                labelText: 'Phone Number'),
                            validator: (value) {
                              if (value!.length == 10 && value != null) {
                                _phoneno = value;
                              } else {
                                return "Valid phone number is required";
                              }
                            }),
                        SizedBox(height: 6.h),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            onSaved: (value) => _roomno = value,

                            //controller: ,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: TextStyle(
                              fontSize: 14.sp,
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
                        SizedBox(height: 6.h),
                        DropdownButtonFormField<String>(
                          value: hostelDropDown,
                          hint: Text(
                            'Hostel Number',
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          onChanged: (newValue) =>
                              setState(() => hostelDropDown = newValue),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Select hostel number";
                            } else {
                              hostelDropDown = value;
                              return null;
                            }
                          },
                          items: ['Hostel-1', 'Hostel-2']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        // Container(
                        //   height: heightMobile * 0.065,
                        //   width: widthMobile * 0.9,
                        //   margin: EdgeInsets.all(0),
                        //   child: DropdownButtonHideUnderline(
                        //     child: GFDropdown(
                        //       padding: const EdgeInsets.all(13),
                        //       borderRadius: BorderRadius.circular(5),
                        //       border: const BorderSide(
                        //           color: Colors.black12, width: 1),
                        //       dropdownButtonColor: Colors.white,
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: heightMobile * 0.02,
                        //       ),
                        //       value: hostelDropDown,

                        //       onChanged: (newValue) =>
                        //         setState(() =>
                        //           hostelDropDown = newValue as String?,

                        //         ),

                        //       hint: Text(
                        //         "Hostel",
                        //       ),
                        //       items: ['Hostel 1', 'Hostel 2']
                        //           .map((value) => DropdownMenuItem(
                        //                 value: value,
                        //                 child: Text(value),
                        //               ))
                        //           .toList(),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 50.h),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                primary: Color(0Xff15609c),
                                padding: EdgeInsets.all(12),
                                // padding: const EdgeInsets.all(10),
                                minimumSize:
                                    Size(MediaQuery.of(context).size.width,38.h)),
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
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
                                    'hostelno': hostelDropDown,
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
