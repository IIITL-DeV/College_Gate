// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/student/complete_profile.dart';
import 'package:college_gate/UI/student/readytogo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:intl/intl.dart';

class ExitForm extends StatefulWidget {
  const ExitForm({Key? key}) : super(key: key);

  @override
  _ExitFormState createState() => _ExitFormState();
}

class _ExitFormState extends State<ExitForm> {
  String? dropdownValue;
  String? _profilePicUrl,
      _username,
      _enrollmentNo,
      _email,
      _roomno,
      _phoneno,
      _recexittime,
      _recexitdate;
  final _formKey = GlobalKey<FormState>();

  Future<void> _getphone() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _phoneno = value.data()!['phone'].toString();
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
      print("Name isssssssssssssssssssssssssssssss $_username");
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

  Future<void> _getroom() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _roomno = value.data()!['room'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getUserName();
    _getroom();
    _getrollno();
    _getphone();
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

  Widget _buildHostel() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(0),
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          padding: const EdgeInsets.all(15),
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Colors.white,
          value: dropdownValue,
          onChanged: (newValue) {
            setState(() {
              dropdownValue = newValue as String?;
            });
            print('value issssssssssssssss   $dropdownValue');
          },
          //                 onChanged: (newValue) =>
          //     setState(() => dropdownValue = newValue as String?),
          // validator: (value) => value == null ? 'field required' : null,
          hint: Text("Purpose"),
          items: ['Outing', 'Home', 'Others']
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildYear() {
    return TextFormField(
        initialValue: _phoneno!,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(labelText: 'Phone number'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Phone number is Required";
          } else {
            return null;
          }
        });
  }

  Widget _buildTime() {
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
                  _recexitdate = value;
                  FirebaseFirestore.instance
                      .collection('studentUser')
                      .doc((FirebaseAuth.instance.currentUser!).uid)
                      .set({
                    'date': value,
                  }, SetOptions(merge: true));
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
              initialValue: DateFormat('kk:mm a').format(times),
              // decoration: const InputDecoration(labelText: 'Time'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Time is Required";
                } else {
                  _recexittime = value;
                  FirebaseFirestore.instance
                      .collection('studentUser')
                      .doc((FirebaseAuth.instance.currentUser!).uid)
                      .set({'time': value}, SetOptions(merge: true));
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xff15609c),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => {Navigator.pop(context)}),
        title: const Text(
          "Exit Form",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildName(),
                  _buildRoll(),
                  _buildYear(),
                  _buildRoom(),
                  SizedBox(height: 20),
                  _buildTime(),
                  SizedBox(height: 20),
                  _buildHostel(),
                  _buildMessage(),
                  SizedBox(height: 50),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                          primary: Color(0Xff15609c),
                          padding: const EdgeInsets.all(13),
                          // padding: const EdgeInsets.all(10),
                          minimumSize: const Size(double.infinity, 30)),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
                                        .uid)
                                    .set({'exitisapproved': false},
                                        SetOptions(merge: true)),
                                FirebaseFirestore.instance
                                    .collection('studentUser')
                                    .doc((FirebaseAuth.instance.currentUser!)
                                        .uid)
                                    .set({'purpose': dropdownValue},
                                        SetOptions(merge: true)),
                                FirebaseFirestore.instance
                                    .collection('studentRegister')
                                    .doc()
                                    .set({
                                  'exittime': _recexittime,
                                  'exitdate': _recexitdate,
                                  'name': _username,
                                }, SetOptions(merge: true)),
                                // FirebaseFirestore.instance
                                //     .collection('studentRegister')
                                //     .doc()
                                //     .set({'exitdate': _recexitdate},
                                //         SetOptions(merge: true)),
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
