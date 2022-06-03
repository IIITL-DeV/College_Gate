import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

<<<<<<< HEAD
=======
import '../../main.dart';



>>>>>>> e9f01e98ce949d3f11007629c0b2934cd2ba2fcf
class DeliveryEntry extends StatefulWidget {
  const DeliveryEntry({Key? key}) : super(key: key);

  @override
  _DeliveryEntryState createState() => _DeliveryEntryState();
}

class _DeliveryEntryState extends State<DeliveryEntry> {
  final _formKey = GlobalKey<FormState>();
  String? name, vehicleno, _purpose, entrytime, entrydate;

  Widget _buildpurpose() {
    return DropdownButtonFormField<String>(
      value: _purpose,
      hint: Text(
        'Purpose',
      ),
      style: TextStyle(
        color: Colors.black,
        // fontSize: heightMobile * 0.02,
      ),
      onChanged: (newValue) => setState(() => _purpose = newValue),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Select purpose";
        } else {
          _purpose = value;
          return null;
        }
      },
      items: ['Delivery', 'Working Staff', 'Appointment', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
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
                  exitdate = value;

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
                  exittime = value;
                  return null;
                }
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
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
          "Guest Entry Form",
          style: TextStyle(color: Colors.white, fontSize: heightMobile * 0.025),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: heightMobile * 0.04, horizontal: widthMobile * 0.08),
          child: Form(
              child: Center(
            child: Column(
              children: [
                SizedBox(height: heightMobile * 0.02),
                SizedBox(
                  height: heightMobile * 0.13,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1500),
                    child: Image.asset(
                      "assets/entry.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  height: heightMobile * 0.02,
                ),
                customTextField("Name", "", heightMobile * 0.021),
                SizedBox(height: heightMobile * 0.009),
                customTextField("Vehicle Number", "", heightMobile * 0.021),
                //SizedBox(height: heightMobile * 0.009),
                SizedBox(height: heightMobile * 0.04),
                _buildTime(),
                SizedBox(height: heightMobile * 0.03),
                _buildpurpose(),
                SizedBox(height: heightMobile * 0.009),
                _purpose == "Appointment"
                    ? customTextField("Phone Number", "", heightMobile * 0.021)
                    : SizedBox.shrink(),
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
<<<<<<< HEAD
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection('studentUser')
                          .doc((FirebaseAuth.instance.currentUser!).email)
                          .set({
                        'guestentrydate': entrydate,
                        'guestentrytime': entrytime,
                        'guestentryname': name,
                        'huestvehicleno': vehicleno,
                        'guestpurpose': _purpose
                      }, SetOptions(merge: true));
                    })
              ],
            ),
          )),
=======
                    SizedBox(height: heightMobile * 0.02,),
                    customTextField("Name", "", heightMobile * 0.021),
                    SizedBox(height: heightMobile * 0.009),
                    customTextField("Vehicle Number", "", heightMobile * 0.021),
                    //SizedBox(height: heightMobile * 0.009),
                    SizedBox(height: heightMobile * 0.04),
                    _buildTime(),
                    SizedBox(height: heightMobile * 0.03),
                    _buildHostel(),
                    SizedBox(height: heightMobile * 0.009),
                    dropdownValue == "Appointment" ? customTextField("Phone Number","", heightMobile * 0.021): SizedBox.shrink(),
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

                          flutterToast("Entry has been added.");
                          Navigator.of(context).pop();

                        })
                  ],
                ),
              )
          ),
>>>>>>> e9f01e98ce949d3f11007629c0b2934cd2ba2fcf
        ),
      ),
    );
  }

  Widget customTextField(String lab, String initValue, double fsize) {
    return TextFormField(
      decoration: InputDecoration(labelText: lab.toString()),
      initialValue: initValue,
      //readOnly: read,
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
