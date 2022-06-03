import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';

import '../../main.dart';
import '../warden/viewimage.dart';

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
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    if (_idcard == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        appBar: isEdit
            ? AppBar(
                backgroundColor: Color(0Xff15609c),
                title: Text("Edit Profile",
                    style: TextStyle(fontSize: heightMobile * 0.025)),
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: heightMobile * 0.028,
                    ),
                    onPressed: () {
                      setState(() {
                        isEdit = false;
                      });
                    }),
              )
            : AppBar(
                backgroundColor: Color(0Xff15609c),
                title: Text("Profile",
                    style: TextStyle(fontSize: heightMobile * 0.025)),
                actions: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isEdit = true;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: heightMobile * 0.024),
                          child: Icon(
                            Icons.edit,
                            color: Colors.deepPurple[50],
                            size: heightMobile * 0.027,
                          )),
                    )
                  ]),
        body: SingleChildScrollView(
          child: Container(
              // height: MediaQuery.of(context).size.height,
              width: widthMobile,
              padding: EdgeInsets.symmetric(
                  vertical: heightMobile * 0.04,
                  horizontal: widthMobile * 0.08),
              child: Form(
                  key: _formKey,
                  child: Center(
                      child: Column(
                    children: [
                      // SizedBox(height: heightMobile * 0.015),
                      SizedBox(
                        height: heightMobile * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: GestureDetector(
                              child: Hero(
                                tag: _idcard!,
                                child: Image.network(_idcard!,
                                    fit: BoxFit.contain),
                              ),
                              onTap: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return viewImage(_idcard!);
                                }));
                              }),
                        ),
                      ),
                      SizedBox(height: heightMobile * 0.016),
                      Text(
                        _username!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: heightMobile * 0.024,
                        ),
                      ),
                      SizedBox(height: heightMobile * 0.01),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Enrollnment Number'),
                        initialValue: _enrollmentNo,
                        style: TextStyle(
                          fontSize: heightMobile * 0.021,
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: heightMobile * 0.009),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        initialValue: _email,
                        style: TextStyle(
                          fontSize: heightMobile * 0.021,
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: heightMobile * 0.009),
                      TextFormField(
                          readOnly: !isEdit,
                          decoration:
                              const InputDecoration(labelText: 'Phone Number'),
                          initialValue: _phoneno,
                          style: TextStyle(
                            fontSize: heightMobile * 0.021,
                          ),
                          validator: (value) {
                            if (value == null || value.length != 10) {
                              return "Valid phone number is required";
                            } else {
                              _phoneno = value;
                              return null;
                            }
                          }),
                      SizedBox(height: heightMobile * 0.009),
                      TextFormField(
                          readOnly: !isEdit,
                          decoration:
                              const InputDecoration(labelText: 'Room number'),
                          initialValue: _roomno,
                          style: TextStyle(
                            fontSize: heightMobile * 0.021,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Room number is required";
                            } else {
                              _roomno = value;
                              return null;
                            }
                          }),
                      SizedBox(height: heightMobile * 0.01),
                      isEdit
                          ? DropdownButtonFormField<String>(
                              value: hostelDropDown,
                              hint: Text(
                                'Hostel Number',
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: heightMobile * 0.02,
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
                                fontSize: heightMobile * 0.021,
                              ),
                            ),
                      SizedBox(height: heightMobile * 0.05),
                      isEdit
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                  ),
                                  primary: Color(0Xff15609c),
                                  padding: EdgeInsets.all(heightMobile * 0.017),
                                  // padding: const EdgeInsets.all(10),
                                  minimumSize:
                                      Size(widthMobile, heightMobile * 0.028)),
                              child: Text(
                                'Save Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: heightMobile * 0.02,
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
                                  padding: EdgeInsets.all(heightMobile * 0.017),
                                  // padding: const EdgeInsets.all(10),
                                  minimumSize:
                                      Size(widthMobile, heightMobile * 0.028)),
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  color: Color(0XffDB0000),
                                  fontSize: heightMobile * 0.02,
                                ),
                              ),
                              onPressed: () {
                                /////
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
