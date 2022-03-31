import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/guest/gpending.dart';
import 'package:college_gate/UI/student/requestpending.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class booking extends StatefulWidget {
  const booking({Key? key}) : super(key: key);

  @override
  _bookingState createState() => _bookingState();
}

class _bookingState extends State<booking> {
  final _formKey = GlobalKey<FormState>();
  var v;
  String? ans;
  String? phone, name, genrollnment, gexitdate, gexittime;
  @override
  void initState() {
    super.initState();
  }

  Widget _buildName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Name'),
      //initialValue: _username!,
      validator: (value) {
        // value:
        if (value == null || value.isEmpty) {
          return "Name is required";
        } else {
          name = value;
          // FirebaseFirestore.instance.collection('studentGuest').doc().set({
          //   'guestname': value,
          // }, SetOptions(merge: true));
          return null;
        }
      },
    );
  }

  Widget _buildphone() {
    return TextFormField(
        //initialValue: _phoneno!,
        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(labelText: 'Email ID'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email ID is required";
          } else {
            phone = value;
            return null;
          }
        });
  }

  Widget _buildemail() {
    return TextFormField(
        decoration:
            const InputDecoration(labelText: "Visting student's email id"),
        //initialValue: _enrollmentNo!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Visting student's Email ID is required";
          } else {
            genrollnment = value;
            return null;
          }
        });
  }

  Widget _buildVehicle() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Vehicle Number'));
    //initialValue: _roomno!,
    // validator: (value) {

    // });
  }

  Widget _buildRelation() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Relation/Purpose'),
        //initialValue: _roomno!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Relation/Purpose is required";
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
                  return "Date is required";
                } else {
                  gexitdate = value;

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
                  gexittime = value;

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
          "Appointment Form",
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
                  _buildphone(),
                  _buildemail(),
                  _buildRelation(),
                  SizedBox(height: 20),
                  _buildTime(),
                  SizedBox(height: 20),
                  _buildVehicle(),
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
                                    .collection('studentGuest')
                                    .doc(genrollnment)
                                    .collection('guestUser')
                                    .doc(phone)
                                    .set({
                                  'guestname': name,
                                  'guestphone': phone,
                                  'vistingroll': genrollnment,
                                  'guestentrydate': gexitdate,
                                  'guestentrytime': gexittime,
                                  'gentryisapproved': false
                                }, SetOptions(merge: true)),
                                FirebaseFirestore.instance
                                    .collection('studentGuest')
                                    .doc(genrollnment)
                                    .collection('guestUser')
                                    .doc(phone)
                                    .collection("gentryisapproved")
                                    .doc()
                                    .set({'gentryisapproved': false},
                                        SetOptions(merge: true)),

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => grequestpending(
                                            genrollnment!, phone!))),
                                // v = FirebaseFirestore.instance
                                //     .collection("studentUser")
                                //     .where("email", isEqualTo: email)
                                //     .get(),
                                // ans = v["userid"],
                                // print("answerissssssssssssss$ans")
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
