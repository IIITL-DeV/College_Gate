import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../main.dart';



class DeliveryEntry extends StatefulWidget {
  const DeliveryEntry({Key? key}) : super(key: key);

  @override
  _DeliveryEntryState createState() => _DeliveryEntryState();
}

class _DeliveryEntryState extends State<DeliveryEntry> {
  String? dropdownValue,_recexittime, _recexitdate;

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
          items: ['Delivery', 'Appointment', 'Others']
              .map((value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          ))
              .toList(),
        ),
      ),
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
                  _recexitdate = value;
                  FirebaseFirestore.instance
                      .collection('studentUser')
                      .doc((FirebaseAuth.instance.currentUser!).email)
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
                      .doc((FirebaseAuth.instance.currentUser!).email)
                      .set({'time': value}, SetOptions(merge: true));
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
        ),
      ),
    );
  }


  Widget customTextField(
      String lab, String initValue, double fsize) {
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
