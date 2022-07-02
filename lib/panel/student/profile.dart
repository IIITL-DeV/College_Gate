import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';

import '../../main.dart';
import '../viewimage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _idcard,
      _username,
      _enrollmentNo,
      _email,
      _roomno,
      _phoneno,
      hostelDropDown;
  bool isEdit = false;
  Future<void> getdetails() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).email)
        .get()
        .then((value) {
      setState(() {
        _idcard = value.data()!['idcard'].toString();
        _email = value.data()!['email'].toString();
        _username = value.data()!['name'].toString();
        _enrollmentNo = value.data()!['enrollment'].toString();
        _phoneno = value.data()!['phone'].toString();
        _roomno = value.data()!['room'].toString();
        hostelDropDown = value.data()!['hostelno'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getdetails();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (_idcard == null) {
      return Center(child: CircularProgressIndicator());
    } else
      return Scaffold(
          appBar: isEdit
              ? AppBar(
                  backgroundColor: Color(0Xff15609c),
                  title:
                      Text("Edit Profile", style: TextStyle(fontSize: 18.sp)),
                  centerTitle: true,
                  leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          isEdit = false;
                        });
                      }),
                )
              : AppBar(
                  backgroundColor: Color(0Xff15609c),
                  title: Text("Profile", style: TextStyle(fontSize: 18.sp)),
                  actions: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isEdit = true;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Icon(
                              Icons.edit,
                              color: Colors.deepPurple[50],
                              size: 18.sp,
                            )),
                      )
                    ]),
          body: SingleChildScrollView(
            child: Container(
                // height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 26.h),
                child: Form(
                    key: _formKey,
                    child: Center(
                        child: Column(
                      children: [
                        // SizedBox(height: heightMobile * 0.015),
                        SizedBox(
                          height: 150.h,
                          child: GestureDetector(
                              child: _idcard == null
                                  ? CircularProgressIndicator()
                                  : Hero(
                                      tag: _idcard!,
                                      child: _idcard == null
                                          ? CircleAvatar(
                                              radius: 70.r,
                                              backgroundImage: AssetImage(
                                                  "assets/profile_darkbluecolor.png"),
                                            )
                                          : CircleAvatar(
                                              radius: 70.r,
                                              backgroundImage: NetworkImage(
                                                _idcard!,
                                              ),
                                            ),
                                    ),
                              onTap: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return viewImage(_idcard!);
                                }));
                              }),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          _username!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Enrollnment Number'),
                          initialValue: _enrollmentNo,
                          style: TextStyle(
                            fontSize: 15.sp,
                          ),
                          readOnly: true,
                        ),
                        SizedBox(height: 5.h),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          initialValue: _email,
                          style: TextStyle(
                            fontSize: 15.sp,
                          ),
                          readOnly: true,
                        ),
                        SizedBox(height: 5.h),
                        TextFormField(
                            readOnly: !isEdit,
                            decoration: const InputDecoration(
                                labelText: 'Phone Number'),
                            initialValue: _phoneno,
                            style: TextStyle(
                              fontSize: 15.sp,
                            ),
                            validator: (value) {
                              if (value == null || value.length != 10) {
                                return "Valid phone number is required";
                              } else {
                                _phoneno = value;
                                return null;
                              }
                            }),
                        SizedBox(height: 5.h),
                        TextFormField(
                            readOnly: !isEdit,
                            decoration:
                                const InputDecoration(labelText: 'Room number'),
                            initialValue: _roomno,
                            style: TextStyle(
                              fontSize: 15.sp,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Room number is required";
                              } else {
                                _roomno = value;
                                return null;
                              }
                            }),
                        SizedBox(height: 5.h),
                        isEdit
                            ? DropdownButtonFormField<String>(
                                value: hostelDropDown,
                                hint: Text(
                                  'Hostel Number',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
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
                                items: [
                                  'Hostel-1',
                                  'Hostel-2'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                            : TextFormField(
                                readOnly: !isEdit,
                                decoration:
                                    const InputDecoration(labelText: 'Hostel'),
                                initialValue: hostelDropDown,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                ),
                              ),
                        SizedBox(height: 40.h),
                        isEdit
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                    ),
                                    primary: Color(0Xff15609c),
                                    padding: EdgeInsets.all(12),
                                    // padding: const EdgeInsets.all(10),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width,
                                        38.h)),
                                child: Text(
                                  'Save Details',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Changes Saved')),
                                    );

                                    await FirebaseFirestore.instance
                                        .collection('studentUser')
                                        .doc((await FirebaseAuth
                                            .instance.currentUser!.email))
                                        .update(
                                      {
                                        'room': _roomno,
                                        'phone': _phoneno,
                                        'hostelno': hostelDropDown
                                      },
                                    );
                                    setState(() {
                                      isEdit = false;
                                    });
                                  } else {
                                    print("Not validated");
                                  }

                                  flutterToast("Profile has been updated.");

                                  setState(() {
                                    isEdit = false;
                                  });
                                  /////
                                })
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                    ),
                                    primary: Colors.white,
                                    padding: EdgeInsets.all(12),
                                    // padding: const EdgeInsets.all(10),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width,
                                        38.h)),
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Color(0XffDB0000),
                                    fontSize: 16.sp,
                                  ),
                                ),
                                onPressed: () {
                                  AuthMethods().logout().then((s) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignIn()));
                                  });
                                })

                        // SizedBox(height: heightMobile * 0.02),
                        // Row(children: [
                        //   Text("ID Card",
                        //       style: TextStyle(
                        //         fontSize: heightMobile * 0.021,
                        //       )),
                        //   SizedBox(
                        //     width: widthMobile * 0.54,
                        //   ),
                        //   GestureDetector(
                        //     onTap: () {
                        //       Navigator.push(context,
                        //           MaterialPageRoute(builder: (context) => viewID()));
                        //     },
                        //     child: Text(
                        //       "View",
                        //       style: TextStyle(
                        //         color: Colors.blue,
                        //         fontSize: heightMobile * 0.021,
                        //       ),
                        //     ),
                        //   )
                        // ]),

                        // Container(
                        //   height: 50,
                        //   width: MediaQuery.of(context).size.width,
                        //   margin: EdgeInsets.all(0),
                        //   child: DropdownButtonHideUnderline(
                        //     child: GFDropdown(
                        //       padding: const EdgeInsets.all(15),
                        //       borderRadius: BorderRadius.circular(5),
                        //       border:
                        //           const BorderSide(color: Colors.black12, width: 1),
                        //       dropdownButtonColor: Colors.white,
                        //       value: dropdownValue,
                        //       onChanged: (newValue) {
                        //         setState(() {
                        //           dropdownValue = newValue as String?;
                        //         });
                        //         print('value issssssssssssssss   $dropdownValue');
                        //       },
                        //       //                 onChanged: (newValue) =>
                        //       //     setState(() => dropdownValue = newValue as String?),
                        //       // validator: (value) => value == null ? 'field required' : null,
                        //       hint: Text("Sign in as"),
                        //       items: ['Student', 'Gatekeeper', 'Warden']
                        //           .map((value) => DropdownMenuItem(
                        //                 value: value,
                        //                 child: Text(value),
                        //               ))
                        //           .toList(),
                        //     ),
                        //   ),
                        // ),

                        //   SizedBox(height: 50.0),

                        //   ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //           shape: new RoundedRectangleBorder(
                        //             borderRadius: new BorderRadius.circular(15.0),
                        //           ),
                        //           primary: Color(0Xff15609c),
                        //           padding: const EdgeInsets.all(13),
                        //           minimumSize: const Size(double.infinity, 30)),
                        //       child: const Text(
                        //         'Done',
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 16,
                        //         ),
                        //       ),
                        //       onPressed: () async {
                        //         if (_formKey.currentState!.validate()) {
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(content: Text('Processing Data')),
                        //           );
                        //           studentHome();
                        //           await FirebaseFirestore.instance
                        //               .collection('studentUser')
                        //               .doc((await FirebaseAuth.instance.currentUser!)
                        //                   .uid)
                        //               .set({'room': _roomno}, SetOptions(merge: true));
                        //           // print("room no issssssssssssss $_roomno");

                        //           await FirebaseFirestore.instance
                        //               .collection('studentUser')
                        //               .doc((await FirebaseAuth.instance.currentUser!)
                        //                   .uid)
                        //               .set(
                        //                   {'phone': _phoneno}, SetOptions(merge: true));
                        //           // print("room no issssssssssssss $_roomno");

                        //           await FirebaseFirestore.instance
                        //               .collection('studentUser')
                        //               .doc((await FirebaseAuth.instance.currentUser!)
                        //                   .uid)
                        //               .set({'signinas': dropdownValue},
                        //                   SetOptions(merge: true));
                        //         } else {
                        //           print("Not validated");
                        //         }
                        //         Navigator.pushReplacement(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => studentHome()));
                        //       })

                        //   // GestureDetector(
                        //   //   onTap: () => {
                        //   //     if (_formKey.currentState!.validate())
                        //   //       {
                        //   //         ScaffoldMessenger.of(context).showSnackBar(
                        //   //           const SnackBar(
                        //   //               content: Text('Processing Data')),
                        //   //         ),
                        //   //         studentHome()
                        //   //       }
                        //   //     else
                        //   //       {print("Not validated")},
                        //   //   },
                        //   //   child: Container(
                        //   //       decoration: BoxDecoration(
                        //   //         borderRadius: BorderRadius.circular(15),
                        //   //         color: Color(0Xff15609c),
                        //   //       ),
                        //   //       height: 50,
                        //   //       width: 510,
                        //   //       //color: Colors.blue[800],
                        //   //       child: Center(
                        //   //         child: Text("Done",
                        //   //             style: TextStyle(
                        //   //                 color: Colors.white, fontSize: 15)),
                        //   //       )),
                        //   // ),
                      ],
                    )))),
          ));
  }
}
