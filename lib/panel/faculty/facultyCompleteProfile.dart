import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/faculty/facultyidcard.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FacultyCompleteProfile extends StatefulWidget {
  const FacultyCompleteProfile({Key? key}) : super(key: key);

  @override
  _FacultyCompleteProfileState createState() => _FacultyCompleteProfileState();
}

class _FacultyCompleteProfileState extends State<FacultyCompleteProfile> {
  String? _username, _designation, _email, _roomno, _phoneno;

  Future<void> _getUserDetails() async {
    FirebaseFirestore.instance
        .collection('facultyUser')
        .doc(await (FirebaseAuth.instance.currentUser)!.email)
        .get()
        .then((value) {
      setState(() {
        _username = value.data()!['name'].toString();

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
    }
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
          padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 26.h),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
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
                    decoration: const InputDecoration(labelText: 'Name'),
                    initialValue: _username,
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 6.h),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    initialValue: _email,
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 6.h),
                  //SizedBox(height: heightMobile * 0.009),
                  //phone number
                  TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) => _phoneno = value,
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                      validator: (value) {
                        if (value!.length == 10) {
                          _phoneno = value;
                        } else {
                          return "Valid phone number is required";
                        }
                      }),
                  //SizedBox(height: heightMobile * 0.009),
                  SizedBox(height: 6.h),
                  TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Designation'),
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                      // readOnly: true,
                      onSaved: (value) => _designation = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Designation is Required";
                        } else {
                          _designation = value;
                        }
                      }),
                  //SizedBox(height: heightMobile * 0.009),
                  SizedBox(height: 6.h),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _roomno = value,

                      //controller: ,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                      decoration:
                          const InputDecoration(labelText: 'Office Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Office number is required";
                        } else {
                          _roomno = value;
                        }
                      }),
                  //SizedBox(height: heightMobile * 0.009),
                  //customTextField("Name", "Jagnik Chaurasiya", heightMobile * 0.021, true),
                  //
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
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      onPressed: () async {
                        print(_designation);

                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );

                          await FirebaseFirestore.instance
                              .collection('facultyUser')
                              .doc((await FirebaseAuth
                                  .instance.currentUser!.email))
                              .update(
                            {
                              'Designation': _designation,
                              'phone': _phoneno,
                              'officeno': _roomno
                            },
                          );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => facultyidcard(
                                        isnewuser: true,
                                      )));
                        } else {
                          print("Not validated");
                        }
                        ;
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextField(
      String lab, String initValue, double fsize, bool read) {
    return TextFormField(
      decoration: InputDecoration(labelText: lab.toString()),
      initialValue: initValue,
      readOnly: read,
      style: TextStyle(
        fontSize: fsize,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required Field";
        } else {
          return null;
        }
      },
    );
  }
}
