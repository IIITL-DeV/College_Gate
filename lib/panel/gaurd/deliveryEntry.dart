import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class DeliveryEntry extends StatefulWidget {
  const DeliveryEntry({Key? key}) : super(key: key);

  @override
  _DeliveryEntryState createState() => _DeliveryEntryState();
}

class _DeliveryEntryState extends State<DeliveryEntry> {
  final _formKey = GlobalKey<FormState>();
  String? name, vehicleno, _purpose, entrytime, entrydate, _phone;

  Widget _buildName() {
    return TextFormField(
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(labelText: 'Name',labelStyle: TextStyle(fontSize: 15.sp)),
      validator: (value) {
        // value:
        if (value == null || value.isEmpty) {
          return "Name is Required";
        } else {
          name = value;
          return null;
        }
      },
    );
  }

  Widget _buildVehicle() {
    return TextFormField(
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(labelText: 'Vehicle Number',labelStyle: TextStyle(fontSize: 15.sp)),
      validator: (value) {
        // value:
        if (value == null || value.isEmpty) {
          return "Vehicle number is Required";
        } else {
          vehicleno = value;
          return null;
        }
      },
    );
  }

  Widget _buildpurpose() {
    return DropdownButtonFormField<String>(
      value: _purpose,
      hint: Text(
        'Purpose',
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 15.sp,
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
          child: Text(value,style: TextStyle(fontSize: 16.sp),),
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
            readOnly: true,
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
                    width: 1.w,
                  ),
                ),
              ),
              initialValue: DateFormat('dd-MM-yyyy').format(times),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Date is Required";
                } else {
                  entrydate = value;

                  return null;
                }
              }),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: TextFormField(
            readOnly: true,
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
                    width: 1.w,
                  ),
                ),
              ),
              initialValue: DateFormat('HH:mm a').format(times),
              // decoration: const InputDecoration(labelText: 'Time'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Time is Required";
                } else {
                  entrytime = value;
                  return null;
                }
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56.h,
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Text(
          "Guest Entry Form",
          style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 40.h, horizontal: 20.w),
          child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    SizedBox(
                      height: 108.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: Image.asset(
                          "assets/entry.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _buildName(),

                    SizedBox(height: 8.h),
                    _buildVehicle(),
                    //SizedBox(height: heightMobile * 0.009),
                    SizedBox(height: 24.h),
                    _buildTime(),
                    SizedBox(height: 24.h),
                    _buildpurpose(),
                    SizedBox(height: 8.h),
                    _purpose == "Appointment"
                        ? customTextField(
                            "Phone Number", "", 16.h)
                        : SizedBox.shrink(),
                    SizedBox(height: 50.h),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.r),
                            ),
                            primary: Color(0Xff15609c),
                            padding: EdgeInsets.all(15.h),
                            // padding: const EdgeInsets.all(10),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width,50.h)),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );

                            FirebaseFirestore.instance
                                .collection('guestRegister')
                                .doc(name! + vehicleno!)
                                .set({
                              'name': name,
                              'vehicleno': vehicleno,
                              'entrydate': entrydate,
                              'entrytime': entrytime,
                              'entryisapproved': true,
                              'exitdate': null,
                              'exittime': null,
                              'purpose': _purpose,
                            }, SetOptions(merge: true));

                            Navigator.pop(context);
                          } else {
                            print("Not validated");
                          }
                        })
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget customTextField(String lab, String initValue, double fsize) {
    return TextFormField(
      decoration: InputDecoration(labelText: lab.toString(),labelStyle: TextStyle(fontSize: 15.sp)),
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
