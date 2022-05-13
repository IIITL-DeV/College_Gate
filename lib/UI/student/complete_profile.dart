import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/UI/student/exit_screen.dart';
import 'package:college_gate/UI/student/homepagecard.dart';
import 'package:college_gate/UI/student/idcardImage.dart';
import 'package:college_gate/services/auth.dart';
import 'package:college_gate/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:college_gate/helperfunctions/sp_helper.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class completeProfile extends StatefulWidget {
  @override
  _completeProfileState createState() => _completeProfileState();
}

class _completeProfileState extends State<completeProfile> {
  String? _profilePicUrl, _username, _enrollmentNo, _email, _roomno, _phoneno;
  // getThisUserInfo() async {
  //   QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo();
  //   //jab where order by krte hai toh query snapshot bnti hai mtlb collection of doc but hame pata hai ke sirf he data aayega toh haam [0] index use kr rhe wo extract krne ke liye

  //   setState(() {
  //     name = "${querySnapshot.docs[0]["name"]}";
  //     profilePicUrl = "${querySnapshot.docs[0]["profileUrl"]}";
  //     enrollmentNo = "${querySnapshot.docs[0]["enrollment"]}";
  //     email = "${querySnapshot.docs[0]["email"]}";
  //     print(name);
  //   });
  // }
  Future<void> _getprofilepicUrl() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _profilePicUrl = value.data()!['profileUrl'].toString();
      });
    });
  }

  Future<void> _getemail() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _email = value.data()!['email'].toString();
      });
    });
  }

  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _username = value.data()!['name'].toString();
      });
    });
  }

  Future<void> _getrollno() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _enrollmentNo = value.data()!['enrollment'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getUserName();
    _getprofilepicUrl();
    _getrollno();
    _getemail();
  }

  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    if (_profilePicUrl == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0Xff15609c),
            title: Text("College Gate",style: TextStyle(fontSize: heightMobile * 0.025)),
            actions: [
              InkWell(
                onTap: () {
                  AuthMethods().logout().then((s) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: heightMobile * 0.024),
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.deepPurple[50],
                      size: heightMobile * 0.027,
                    )),
              )
            ]),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: heightMobile * 0.04, horizontal: widthMobile * 0.08),
              child: Form(
                  key: _formKey,
                  child: Center(
                      child: Column(
                    children: [
                      SizedBox(height: heightMobile * 0.03),
                      SizedBox(
                        height: heightMobile * 0.13,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1500),
                          child: Image.network(
                            _profilePicUrl!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: heightMobile * 0.015),
                      TextFormField(
                          decoration: const InputDecoration(labelText: 'Name'),
                          initialValue: _username,
                          style: TextStyle(
                            fontSize:heightMobile * 0.021,
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
                      SizedBox(
                          height: heightMobile * 0.009),
                      TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Enrollnment Number'),
                          initialValue: _enrollmentNo,
                          style: TextStyle(
                            fontSize:
                            heightMobile * 0.021,
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
                      SizedBox(
                          height: heightMobile * 0.009),
                      TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          initialValue: _email,
                          style: TextStyle(
                            fontSize:
                            heightMobile * 0.021,
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
                      SizedBox(
                          height: heightMobile * 0.009),
                      TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onSaved: (value) => _phoneno = value,
                          style: TextStyle(
                            fontSize:
                            heightMobile * 0.021,
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

                      SizedBox(
                          height: heightMobile * 0.009),
                      TextFormField(
                          onSaved: (value) => _roomno = value,

                          //controller: ,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: TextStyle(
                            fontSize:
                            heightMobile * 0.021,
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
                      SizedBox(
                          height: heightMobile * 0.02),

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
                              fontSize:
                              heightMobile * 0.021,
                            ),
                            value: dropdownValue,
                            onChanged: (newValue) {
                              setState(() {
                                dropdownValue = newValue as String?;
                              });
                            },
                            //                 onChanged: (newValue) =>
                            //     setState(() => dropdownValue = newValue as String?),
                            // validator: (value) => value == null ? 'field required' : null,
                            hint: Text(
                              "Sign in as",
                            ),

                            items: ['Student', 'Faculty']
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),

                      SizedBox(
                          height: heightMobile * 0.028),

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
                                  .doc(
                                      (await FirebaseAuth.instance.currentUser!)
                                          .uid)
                                  .set({'room': _roomno},
                                      SetOptions(merge: true));
                              // print("room no issssssssssssss $_roomno");

                              await FirebaseFirestore.instance
                                  .collection('studentUser')
                                  .doc(
                                      (await FirebaseAuth.instance.currentUser!)
                                          .uid)
                                  .set({'phone': _phoneno},
                                      SetOptions(merge: true));
                              // print("room no issssssssssssss $_roomno");

                              await FirebaseFirestore.instance
                                  .collection('studentUser')
                                  .doc(
                                      (await FirebaseAuth.instance.currentUser!)
                                          .uid)
                                  .set({'signinas': dropdownValue},
                                      SetOptions(merge: true));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => idcardImage()));
                            } else {
                              print("Not validated");
                            }
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => idcardImage()));
                          })

                      // GestureDetector(
                      //   onTap: () => {
                      //     if (_formKey.currentState!.validate())
                      //       {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           const SnackBar(
                      //               content: Text('Processing Data')),
                      //         ),
                      //         studentHome()
                      //       }
                      //     else
                      //       {print("Not validated")},
                      //   },
                      //   child: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(15),
                      //         color: Color(0Xff15609c),
                      //       ),
                      //       height: 50,
                      //       width: 510,
                      //       //color: Colors.blue[800],
                      //       child: Center(
                      //         child: Text("Done",
                      //             style: TextStyle(
                      //                 color: Colors.white, fontSize: 15)),
                      //       )),
                      // ),
                    ],
                  )))),
        ));
  }
}
