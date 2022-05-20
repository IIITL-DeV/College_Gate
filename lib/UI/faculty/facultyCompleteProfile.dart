import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FacultyCompleteProfile extends StatefulWidget {
  const FacultyCompleteProfile({Key? key}) : super(key: key);

  @override
  _FacultyCompleteProfileState createState() => _FacultyCompleteProfileState();
}

class _FacultyCompleteProfileState extends State<FacultyCompleteProfile> {
  String? _phoneno;
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0Xff15609c),
          title: Text("College Gate",
              style: TextStyle(fontSize: heightMobile * 0.025)),
          actions: [
            InkWell(
              onTap: () {},
              child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: heightMobile * 0.024),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.deepPurple[50],
                    size: heightMobile * 0.027,
                  )),
            )
          ]),
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
                        "assets/exit.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: heightMobile * 0.015),
                  customTextField(
                      "Name", "Jagnik Chaurasiya", heightMobile * 0.021, true),
                  SizedBox(height: heightMobile * 0.009),
                  customTextField("Email", "jagnik@iiitl.ac.in",
                      heightMobile * 0.021, true),
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
                        if (value!.length == 10 && value != null) {
                          _phoneno = value;
                        } else {
                          return "Valid phone number is required";
                        }
                      }),
                  //customTextField("Phone Number", "", heightMobile * 0.021, false),
                  SizedBox(height: heightMobile * 0.009),
                  customTextField(
                      "Designation", "", heightMobile * 0.021, false),
                  SizedBox(height: heightMobile * 0.009),
                  customTextField(
                      "Office Number", "", heightMobile * 0.021, false),
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
                      onPressed: () async {})
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
