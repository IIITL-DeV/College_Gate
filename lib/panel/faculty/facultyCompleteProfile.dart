import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/faculty/facultyidcard.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    if (_username == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: heightMobile * 0.028,
                child: Image.asset("assets/cg_white.png")),
            SizedBox(
              width: 10,
            ),
            Text("College Gate",
                style: TextStyle(fontSize: heightMobile * 0.028)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: heightMobile * 0.04, horizontal: widthMobile * 0.08),
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
                  ),
                  SizedBox(height: heightMobile * 0.009),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    initialValue: _email,
                    style: TextStyle(
                      fontSize: heightMobile * 0.02,
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: heightMobile * 0.009),
                  //phone number
                  TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) => _phoneno = value,
                      style: TextStyle(
                        fontSize: heightMobile * 0.021,
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
                  SizedBox(height: heightMobile * 0.009),
                  TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Designation'),
                      style: TextStyle(
                        fontSize: heightMobile * 0.02,
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
                  SizedBox(height: heightMobile * 0.009),
                  TextFormField(
                      onSaved: (value) => _roomno = value,

                      //controller: ,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: heightMobile * 0.02,
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
                  SizedBox(height: heightMobile * 0.07),
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
