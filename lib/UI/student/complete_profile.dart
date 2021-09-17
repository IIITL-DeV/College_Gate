import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/UI/student/studentHome.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';

class completeProfile extends StatefulWidget {
  const completeProfile({Key? key}) : super(key: key);

  @override
  _completeProfileState createState() => _completeProfileState();
}

class _completeProfileState extends State<completeProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0Xff15609c),
          title: Text("College Gate"),
          actions: [
            InkWell(
              onTap: () {
                AuthMethods().logout().then((s) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.deepPurple[50],
                  )),
            )
          ]),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          // key: _formKey,
          child: Center(
            child: Column(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius:
                //         BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                //     image: DecorationImage(
                //       image: AssetImage("assets/collegegate-01.png"),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                SizedBox(height: 20.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(1500),
                  child: Image.network(
                    "https://lh3.googleusercontent.com/a/AATXAJxUk4eg4_2mYAEOjU7K6dx46JYR1Q6HW0WlMPEn=s96-c",
                    // height: 150,
                    // width: 150,
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Name*',
                    ),
                    initialValue: "Anu Kumari"),
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: InputDecoration(hintText: 'Phone Number*'),
                    //obscureText: true,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter your phone number' : null,
                    onChanged: (val) {
                      setState(() {});
                    }),
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: InputDecoration(hintText: 'Email*'),
                    initialValue: "lit2019072@iiitl.ac.in"),
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: InputDecoration(hintText: 'Profession*'),
                    initialValue: "Student"),

                SizedBox(height: 20.0),

                TextFormField(
                    decoration: InputDecoration(hintText: 'Enrollment number'),
                    initialValue: "lit2019072"),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Permanent Address'),
                ),
                SizedBox(height: 50.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => studentHome()));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0Xff15609c),
                      ),
                      height: 50,
                      width: 510,
                      //color: Colors.blue[800],
                      child: Center(
                        child: Text("Done",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
