import 'package:college_gate/UI/student/studentHome.dart';
import 'package:college_gate/services/auth.dart';
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
              backgroundColor: Colors.indigo[900],
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40.0),
                      TextFormField(
                          decoration: InputDecoration(hintText: 'Email'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email id' : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          decoration: InputDecoration(hintText: 'Password'),
                          obscureText: true,
                          validator: (val) => val!.length < 6
                              ? 'Enter a password with minimun 6 characters'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          }),
                      SizedBox(height: 40.0),
                      RaisedButton(
                          color: Colors.indigo[900],
                          child: Text('Sign In',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => studentHome()));
                            // if (_formKey.currentState!.validate()) {
                            //   setState(() => loading = true);
                            //   dynamic result = await _aut
                            //       .signInEmailAndPassword(email, password);
                            //   if (result == null) {
                            //     setState(() {
                            //       loading = false;
                            //       error = 'Invalid Credentials';
                            //       return error;
                            //     });
                            //   }
                            // }
                          }),
                      SizedBox(
                        height: 12,
                      ),
                      Row(children: <Widget>[
                        Expanded(child: Divider()),
                        Text(
                          "or",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Expanded(child: Divider()),
                      ]),
                      SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            AuthMethods().signInWithGoogle(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(0xffDB4437),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Sign in with Google",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
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
