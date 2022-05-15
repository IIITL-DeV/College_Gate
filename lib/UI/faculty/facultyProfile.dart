import 'package:flutter/material.dart';

class facultyProfile extends StatefulWidget {
  const facultyProfile({Key? key}) : super(key: key);

  @override
  _facultyProfileState createState() => _facultyProfileState();
}

class _facultyProfileState extends State<facultyProfile> {

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: widthMobile,
          padding: EdgeInsets.symmetric(
              vertical: heightMobile * 0.04, horizontal: widthMobile * 0.07),
          child: Form(
              child: Column(
                children: [
                  SizedBox(height: heightMobile * 0.025),
                  SizedBox(
                    height: heightMobile * 0.14,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1500),
                      child: Image.asset(
                        "assets/entry.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: heightMobile * 0.016),
                  Text(
                    "Dr. Vishal Krishna Singh",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: heightMobile * 0.024,
                    ),
                  ),
                  SizedBox(height: heightMobile * 0.02),
                  customTextField("Description", "Deputy Registrar",heightMobile * 0.021),
                  SizedBox(height: heightMobile * 0.012),
                  customTextField("Contact Number", "7856341265",heightMobile * 0.021),
                  SizedBox(height: heightMobile * 0.012),
                  customTextField("Email ID", "vks@iiitl.ac.in",heightMobile * 0.021),
                  SizedBox(height: heightMobile * 0.012),
                  customTextField("Office Number", "337",heightMobile * 0.021),
                ],
              )
          ),

        ),
      ),
    );
  }

  Widget customTextField(String lab,String initValue, double fsize){
    return TextFormField(
      decoration: InputDecoration(labelText: lab.toString()),
      initialValue: initValue,
      style: TextStyle(
        fontSize: fsize,
      ),

    );
  }
}
