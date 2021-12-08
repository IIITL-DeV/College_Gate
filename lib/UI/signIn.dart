import 'package:college_gate/UI/gaurd/gaurd_home.dart';
import 'package:college_gate/UI/guest/guesthome.dart';
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
                                  builder: (context) => GuestHome()));
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
