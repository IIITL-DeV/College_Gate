import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/src/intl/date_format.dart';

import '../../main.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({Key? key}) : super(key: key);

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  String? dropdownValue;
  String? _profilePicUrl,
      _username,
      _enrollmentNo,
      _email,
      _recentrytime,
      _recentrydate,
      _roomno,
      _phoneno,
      _exittime,
      _exitdate;

  final _formKey = GlobalKey<FormState>();

  Future<void> _getdetails() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).email)
        .get()
        .then((value) {
      setState(() {
        _phoneno = value.data()!['phone'].toString();
        _username = value.data()!['name'].toString();
        _exitdate = value.data()!['date'].toString();
        _enrollmentNo = value.data()!['enrollment'].toString();
        _exitdate = value.data()!['date'].toString();
        _exittime = value.data()!['time'].toString();
        _roomno = value.data()!['room'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getdetails();
  }

  Widget _buildName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Name'),
      initialValue: _username!,
      validator: (value) {
        // value:
        if (value == null || value.isEmpty) {
          return "Name is Required";
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildRoll() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Enrollment Number'),
        initialValue: _enrollmentNo!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enrollment number is Required";
          } else {
            return null;
          }
        });
  }

  Widget _buildRoom() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Room Number'),
        initialValue: _roomno!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Room number is Required";
          } else {
            return null;
          }
        });
  }

  Widget _buildYear() {
    return TextFormField(
        initialValue: _phoneno!,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(labelText: 'Phone number'),
        validator: (value) {
          if (value == null || value.length != 10) {
            return "Valid phone number is required";
          } else {
            return null;
          }
        });
  }

  Widget _buildentryTime() {
    DateTime times = DateTime.now();
    return Row(
      children: [
        Expanded(
          child: TextFormField(
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
              initialValue: DateFormat('dd-MM-yyyy').format(times),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Date is Required";
                } else {
                  _recentrydate = value;
                  FirebaseFirestore.instance
                      .collection('studentUser')
                      .doc((FirebaseAuth.instance.currentUser!).email)
                      .set({'entrydate': value}, SetOptions(merge: true));
                  return null;
                }
              }),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
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
              initialValue: DateFormat('kk:mm').format(times),
              // decoration: const InputDecoration(labelText: 'Time'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Time is Required";
                } else {
                  _recentrytime = value;
                  FirebaseFirestore.instance
                      .collection('studentUser')
                      .doc((FirebaseAuth.instance.currentUser!).email)
                      .set({'entrytime': value}, SetOptions(merge: true));
                  return null;
                }
              }),
        ),
      ],
    );
  }

  Widget _buildexitTime() {
    DateTime times = DateTime.now().toUtc().toLocal();
    return Row(
      children: [
        Expanded(
          child: TextFormField(
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
              initialValue: _exitdate,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Date is Required";
                } else {
                  //_exitdate = value;
                  FirebaseFirestore.instance
                      .collection('studentUser')
                      .doc((FirebaseAuth.instance.currentUser!).email)
                      .set({'entrydate': value}, SetOptions(merge: true));
                  return null;
                }
              }),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
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
              initialValue: _exittime,
              // decoration: const InputDecoration(labelText: 'Time'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Time is Required";
                } else {
                  //_exittime = value;
                  FirebaseFirestore.instance
                      .collection('studentUser')
                      .doc((FirebaseAuth.instance.currentUser!).email)
                      .set({'entrytime': value}, SetOptions(merge: true));
                  return null;
                }
              }),
        ),
      ],
    );
  }

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
    var dropdownValue;
    if (_username == null) {
      return Center(child: CircularProgressIndicator());
    }

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
          "Entry Form",
          style: TextStyle(color: Colors.white, fontSize: heightMobile * 0.026),
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
                //mainAxisAlignment: MainAxisAlignment.left(),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: heightMobile * 0.02),
                  Text(
                    "Student details",
                    style: TextStyle(
                        color: Color(0Xff15609c),
                        fontSize: heightMobile * 0.0245,
                        fontWeight: FontWeight.w400),
                  ),

                  // SizedBox(height: 10),
                  _buildName(),
                  _buildRoll(),
                  _buildYear(),
                  _buildRoom(),
                  SizedBox(height: heightMobile * 0.015),
                  Divider(),
                  Text(
                    "Exit details",
                    style: TextStyle(
                      color: Color(0Xff15609c),
                      fontSize: heightMobile * 0.0245,
                    ),
                  ),

                  SizedBox(height: heightMobile * 0.02),
                  _buildexitTime(),
                  SizedBox(height: heightMobile * 0.015),
                  Divider(),
                  Text(
                    "Entry details",
                    style: TextStyle(
                        color: Color(0Xff15609c),
                        fontSize: heightMobile * 0.0245),
                  ),
                  SizedBox(height: heightMobile * 0.02),

                  _buildentryTime(),
                  //SizedBox(height: 20),
                  //  _buildHostel(),
                  //_buildMessage(),
                  SizedBox(height: heightMobile * 0.06),
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
                                    .doc((FirebaseAuth.instance.currentUser!)
                                        .email)
                                    .update(
                                  {'entryisapproved': false},
                                ),
                                //SetOptions(merge: true)),
                                FirebaseFirestore.instance
                                    .collection('studentRegister')
                                    .doc((FirebaseAuth.instance.currentUser!)
                                            .email! +
                                        _exitdate! +
                                        _exittime!)
                                    .update({
                                  'entrydate': _recentrydate,
                                  'entrytime': _recentrytime,
                                }),
                                FirebaseFirestore.instance
                                    .collection('studentUser')
                                    .doc((FirebaseAuth.instance.currentUser!)
                                        .email!)
                                    .set({
                                  'entrydatetime':
                                      _recentrydate! + _recentrytime!,
                                }, SetOptions(merge: true)),

                                flutterToast("Request has been sent."),

                                Navigator.pop(context),
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
