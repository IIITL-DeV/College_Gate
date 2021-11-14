import 'package:college_gate/UI/gaurd/gaurd_home.dart';
import 'package:college_gate/UI/student/complete_profile.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  //neeche nhi kiya because it's a constructor for sate widget;
  //we are passing value inside the widget itself no the state object

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthMethods _aut = AuthMethods();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text('Sign in to College Gate'),
              backgroundColor: Color(0Xff15609c),
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/collegegate-01.png",
                        height: 400,
                        width: 4000,
                      ),
                      //SizedBox(height: 80.0),
                      // DropdownButton(
                      //   hint: _dropDownValue == null
                      //       ? Text('Dropdown')
                      //       : Text(
                      //           _dropDownValue,
                      //           style: TextStyle(color: Colors.blue),
                      //         ),
                      //   isExpanded: true,
                      //   iconSize: 30.0,
                      //   style: TextStyle(color: Colors.blue),
                      //   items: ['One', 'Two', 'Three'].map(
                      //     (val) {
                      //       return DropdownMenuItem<String>(
                      //         value: val,
                      //         child: Text(val),
                      //       );
                      //     },
                      //   ).toList(),
                      //   onChanged: (val) {
                      //     setState(
                      //       () {
                      //         _dropDownValue = val as String;
                      //       },
                      //     );
                      //   },
                      // ),
                      // DropdownButton<String>(
                      //   items: <String>[
                      //     'Student',
                      //     'GateKeeper',
                      //     'Warden',
                      //     'Mess Incharge'
                      //   ].map((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      //   onChanged: (newvalue) {
                      //     setState(() {
                      //       _selectedDesignation = newvalue!;
                      //     });
                      //   },
                      //   hint: Text("     Student     "),
                      // ),
                      //SizedBox(height: 20.0),
                      // TextFormField(
                      //     decoration: InputDecoration(hintText: 'Email'),
                      //     validator: (val) =>
                      //         val!.isEmpty ? 'Enter an email id' : null,
                      //     onChanged: (val) {
                      //       setState(() {
                      //         email = val;
                      //       });
                      //     }),
                      // SizedBox(height: 20.0),
                      // TextFormField(
                      //     decoration: InputDecoration(hintText: 'Password'),
                      //     obscureText: true,
                      //     validator: (val) => val!.length < 6
                      //         ? 'Enter a password with minimun 6 characters'
                      //         : null,
                      //     onChanged: (val) {
                      //       setState(() {
                      //         password = val;
                      //       });
                      //     }),
                      // SizedBox(height: 40.0),
                      // RaisedButton(
                      //     color: Colors.blue[800],
                      //     child: Text('Sign In',
                      //         style: TextStyle(color: Colors.white)),
                      //     onPressed: () {
                      //       Navigator.pushReplacement(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => studentHome()));
                      //       // if (_formKey.currentState!.validate()) {
                      //       //   setState(() => loading = true);
                      //       //   dynamic result = await _aut
                      //       //       .signInEmailAndPassword(email, password);
                      //       //   if (result == null) {
                      //       //     setState(() {
                      //       //       loading = false;
                      //       //       error = 'Invalid Credentials';
                      //       //       return error;
                      //       //     });
                      //       //   }
                      //       // }
                      //     }),
                      // SizedBox(
                      //   height: 12,
                      // ),

                      SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            AuthMethods().signInWithGoogle(context);
                          },
                          child: Container(
                            height: 50,
                            width: 510,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.green,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Center(
                              child: Text(
                                "Sign in with Google",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(children: <Widget>[
                        Expanded(child: Divider()),
                        Text(
                          "or",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Expanded(child: Divider()),
                      ]),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => completeProfile()));
                        },
                        child: Container(
                          height: 50,
                          width: 510,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Color(0Xff15609c),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Center(
                            child: Text(
                              "Continue as Guest",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
